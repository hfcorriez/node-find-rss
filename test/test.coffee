# test dependency
path = require 'path'
assert  = require 'assert'
request = require 'request'

# test framework
finder = require '../lib/find-rss'

titleMatcher = (title) -> title.indexOf('nikezono') > -1 && title.indexOf('Activity') > -1

# test property
body = ""

describe "find-rss", ->

  describe "callback:http url", ->

    it "正常系:返り値が配列",(done)->
      finder "https://github.com/nikezono",(error,candidates)->

        assert.equal error,null
        hasUrl =
          candidates
            .filter (i) -> i.url is "https://github.com/nikezono.atom"
            .length > 0
        assert.ok hasUrl
        done()

    it "正常系:リダイレクト",(done)->

      finder "https://github.com/nikezono/",(error,candidates)->
        assert.equal error,null
        hasUrl =
          candidates
            .filter (i) -> i.url is "https://github.com/nikezono.atom"
            .length > 0
        assert.ok hasUrl
        done()

    it "正常系:feedを直接読ませる",(done)->

      finder "https://github.com/nikezono.atom",(error,candidates)->
        assert.equal error,null
        hasTitle =
          candidates
            .filter (i) -> titleMatcher(i.title)
            .length > 0
        assert.ok hasTitle
        done()

    it "異常系:URLの接続先が存在しない",(done)->

      finder "http://n.o.t.f.o.u.n.d",(error,candidates)->
        assert.ok error?
        done()

  describe "options",->

    it "正常系:faviconを取得しない",(done)->

      finder = require '../lib/find-rss'
      finder.setOptions
        favicon:false

      # @note:2014/10/14付けでhtmlにfaviconの場所が書いてない
      finder "http://apple.com",(error,candidates)->
        assert.equal error,null
        assert.equal candidates[0].favicon, ''
        done()

    it "正常系:getDetail:Detail:false",(done)->

      finder = require '../lib/find-rss'
      finder.setOptions
        getDetail:false

      finder "http://github.com/nikezono",(error,candidates)->
        assert.equal error,null
        hasTitle =
          candidates
            .filter (i) -> i.title is 'atom'
            .length > 0
        assert.ok hasTitle
        done()


    it "正常系:getDetail:Detailを取得する",(done)->

      finder = require '../lib/find-rss'
      finder.setOptions
        getDetail:true
      finder "http://github.com/nikezono",(error,candidates)->
        assert.equal error,null
        hasTitle =
          candidates
            .filter (i) -> titleMatcher(i.title)
            .length > 0
        assert.ok hasTitle
        done()

    it "正常系:getDetail:url/sitenameを補完する",(done)->

      finder = require '../lib/find-rss'
      finder.setOptions
        getDetail:true
      finder "http://github.com/nikezono",(error,candidates)->
        assert.equal error,null
        hasUrl =
          candidates
            .filter (i) -> i.url is "http://github.com/nikezono.atom"
            .length > 0
        hasSiteName =
          candidates
            .filter (i) -> i.sitename is "nikezono (Sho Nakazono) · GitHub"
            .length > 0
        assert.ok hasUrl
        assert.ok hasSiteName
        done()


    it "正常系:getDetail:feedを直接読ませる",(done)->

      finder = require '../lib/find-rss'
      finder.setOptions
        getDetail:true
      finder "http://github.com/nikezono.atom",(error,candidates)->
        assert.equal error,null
        assert.ok candidates.length > 0
        hasTitle =
          candidates
            .filter (i) -> titleMatcher(i.title)
            .length > 0
        hasUrl =
          candidates
            .filter (i) -> i.url is "http://github.com/nikezono.atom"
            .length > 0
        hasSiteName =
          candidates
            .filter (i) -> titleMatcher(i.sitename) # 同じものが入る
            .length > 0
        assert.ok hasTitle
        assert.ok hasUrl
        assert.ok hasSiteName
        done()


    it "正常系:getDetail:favicon:両方ON",(done)->

      finder = require '../lib/find-rss'
      finder.setOptions
        getDetail:true
        favicon:true
      finder "http://www.nhk.or.jp",(error,candidates)->
        assert.equal error,null
        hasUrl =
          candidates
            .filter (i) -> i.url is "http://www.nhk.or.jp/rss/news/cat0.xml"
            .length > 0
        hasSiteName =
          candidates
            .filter (i) -> i.sitename is "NHKオンライン" # 同じものが入る
            .length > 0
        hasFavicon =
          candidates
            .filter (i) -> i.favicon is "http://www.nhk.or.jp/favicon.ico"
            .length > 0
        assert.ok hasUrl
        assert.ok hasSiteName
        assert.ok hasFavicon
        done()

# test dependency
path = require 'path'
assert  = require 'assert'
request = require 'request'

# test framework
finder = require '../lib/find-rss'

# test property
body = ""

describe "find-rss", ->

  describe "callback:http url", ->

    it "正常系:返り値が配列",(done)->
      finder "https://github.com/nikezono",(error,candidates)->

        assert.equal error,null
        assert.equal candidates.length,1
        assert.equal candidates[0].url, "https://github.com/nikezono.atom"
        done()

    it "正常系:リダイレクト",(done)->

      finder "https://github.com/nikezono/",(error,candidates)->
        assert.equal error,null
        assert.equal candidates.length,1
        assert.equal candidates[0].url, "https://github.com/nikezono.atom"
        done()

    it "正常系:feedを直接読ませる",(done)->

      finder "https://github.com/nikezono.atom",(error,candidates)->
        assert.equal error,null
        assert.equal candidates.length,1
        assert.equal candidates[0].title, "nikezono's Activity"
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
        assert.equal candidates[0].title,"atom"
        done()


    it "正常系:getDetail:Detailを取得する",(done)->

      finder = require '../lib/find-rss'
      finder.setOptions
        getDetail:true
      finder "http://github.com/nikezono",(error,candidates)->
        assert.equal error,null
        assert.equal candidates[0].title,"nikezono's Activity"
        done()

    it "正常系:getDetail:url/sitenameを補完する",(done)->

      finder = require '../lib/find-rss'
      finder.setOptions
        getDetail:true
      finder "http://github.com/nikezono",(error,candidates)->
        assert.equal error,null
        assert.equal candidates[0].url,"http://github.com/nikezono.atom"
        assert.equal candidates[0].sitename,"nikezono (Sho Nakazono) · GitHub"
        done()


    it "正常系:getDetail:feedを直接読ませる",(done)->

      finder = require '../lib/find-rss'
      finder.setOptions
        getDetail:true
      finder "http://github.com/nikezono.atom",(error,candidates)->
        assert.equal error,null
        assert.equal candidates.length,1
        assert.equal candidates[0].title, "nikezono's Activity"
        assert.equal candidates[0].url, "http://github.com/nikezono.atom"
        assert.equal candidates[0].sitename,"nikezono's Activity" # 同じものが入る
        done()


    it "正常系:getDetail:favicon:両方ON",(done)->

      finder = require '../lib/find-rss'
      finder.setOptions
        getDetail:true
        favicon:true
      finder "http://www.nhk.or.jp",(error,candidates)->
        assert.equal error,null
        assert.equal candidates[0].url, "http://www.nhk.or.jp/rss/news/cat0.xml"
        assert.equal candidates[0].sitename,"NHKオンライン" # 同じものが入る
        assert.equal candidates[0].favicon,"http://www.nhk.or.jp/favicon.ico"
        done()



# test dependency
path = require 'path'
assert  = require 'assert'
csDetector   = require("node-icu-charset-detector")


# test framework
finder = require path.resolve('lib','find-rss')

# test Property
shokai   = "http://shokai.org/blog/"
shokai2  = "http://shokai.org/blog"
apple    = "http://www.apple.com/"
livedoor = "http://news.livedoor.com/"
geta6    = "http://blog.geta6.net"
# findRSS
describe "find-rss", ->

  it "エラー処理できる",->
    finder "egergre",(e,candidates)->
      assert.equal candidates,null
      assert.equal e?, true

  it 'geta6' ,(done)->
    finder geta6,(e,candidates)->
      console.log e if e?
      assert.equal candidates.length,1
      assert.equal e?, false
      done()

  it 'サイト名が保存されている' ,(done)->
    finder apple,(e,candidates)->
      console.log e if e?
      assert.equal candidates[0].sitename, 'Apple'
      assert.equal e?, false
      done()

  it "atomが返せる",(done)->
    finder shokai,(e,candidates)->
      assert.equal candidates.length,1
      done()

  it "リダイレクト対応",(done)->
    finder shokai2,(e,candidates)->
      assert.equal candidates.length,1
      done()

  it "rss/xmlが返せる",(done) ->
    finder apple,(e,candidates)->
      assert.equal candidates?,true
      done()

  it "複数のRSSを配列にしまえる",(done)->
    finder livedoor,(e,candidates)->
      assert.equal candidates.length>1, true
      done()

  it "faviconが取得できる",(done)->
    finder livedoor,(e,candidates)->
      assert.equal candidates[0].favicon?,true
      done()

  it "文字化けしない", (done)->
    finder livedoor,(e,candidates)->
      #テストできない
      console.log candidates[0].title
      done()

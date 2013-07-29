assert = require 'assert'
po = require 'node-po'
fs = require 'fs'
grunt = require 'grunt'

describe 'Extract', ->
    it 'Extracts strings from views', (done) ->
        assert(fs.existsSync('tmp/test1.pot'))

        po.load 'tmp/test1.pot', (catalog) ->
            assert.equal(catalog.items.length, 1)
            assert.equal(catalog.items[0].msgid, 'Hello!')
            assert.equal(catalog.items[0].msgstr, '')
            assert.equal(catalog.items[0].references.length, 1)
            assert.equal(catalog.items[0].references[0], 'test/fixtures/single.html')
            done()

    it 'Merges multiple views into one .pot', (done) ->
        assert(fs.existsSync('tmp/test2.pot'))

        po.load 'tmp/test2.pot', (catalog) ->
            i = catalog.items
            assert.equal(i.length, 2)
            assert.equal(i[0].msgid, 'Hello!')
            assert.equal(i[1].msgid, 'This is a test')
            done()

    it 'Merges duplicate strings with references', (done) ->
        assert(fs.existsSync('tmp/test2.pot'))

        po.load 'tmp/test2.pot', (catalog) ->
            i = catalog.items
            assert.equal(i.length, 2)

            assert.equal(i[0].msgid, 'Hello!')
            assert.equal(i[0].references.length, 2)
            assert.equal(i[0].references[0], 'test/fixtures/single.html')
            assert.equal(i[0].references[1], 'test/fixtures/second.html')

            assert.equal(i[1].msgid, 'This is a test')
            assert.equal(i[1].references.length, 1)
            assert.equal(i[1].references[0], 'test/fixtures/second.html')
            done()

    it 'Extracts plural strings', (done) ->
        assert(fs.existsSync('tmp/test3.pot'))

        po.load 'tmp/test3.pot', (catalog) ->
            i = catalog.items
            assert.equal(i.length, 1)

            assert.equal(i[0].msgid, 'Bird')
            assert.equal(i[0].msgid_plural, 'Birds')
            assert.equal(i[0].msgstr.length, 2)
            assert.equal(i[0].msgstr[0], '')
            assert.equal(i[0].msgstr[1], '')
            done()

    it 'Merges singular and plural strings', (done) ->
        assert(fs.existsSync('tmp/test4.pot'))

        po.load 'tmp/test4.pot', (catalog) ->
            i = catalog.items
            assert.equal(i.length, 1)

            assert.equal(i[0].msgid, 'Bird')
            assert.equal(i[0].msgid_plural, 'Birds')
            assert.equal(i[0].msgstr.length, 2)
            assert.equal(i[0].msgstr[0], '')
            assert.equal(i[0].msgstr[1], '')
            done()

    it 'Warns for incompatible plurals', (done) ->
        grunt.util.spawn {
            cmd: "grunt",
            args: ["nggettext_extract:manual"]
        }, (err) ->
            assert(!fs.existsSync('tmp/test5.pot'))
            done(err)

    it 'Extracts filter strings', (done) ->
        assert(fs.existsSync('tmp/test6.pot'))

        po.load 'tmp/test6.pot', (catalog) ->
            assert.equal(catalog.items.length, 1)
            assert.equal(catalog.items[0].msgid, 'Hello')
            assert.equal(catalog.items[0].msgstr, '')
            assert.equal(catalog.items[0].references.length, 1)
            assert.equal(catalog.items[0].references[0], 'test/fixtures/filter.html')
            done()
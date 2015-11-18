Sinon = require 'sinon'
Chai = require 'chai'
Chai.use require 'sinon-chai'
{expect} = Chai

MockConnection = require '../../../mock/connection'
Protocol = require '../../../../src/adb/protocol'
RootCommand = require '../../../../src/adb/command/host-transport/root'

describe 'RootCommand', ->

  it "should send 'root:'", (done) ->
    conn = new MockConnection
    cmd = new RootCommand conn
    conn.socket.on 'write', (chunk) ->
      expect(chunk.toString()).to.equal \
        Protocol.encodeData('root:').toString()
    setImmediate ->
      conn.socket.causeRead Protocol.OKAY
      conn.socket.causeEnd()
    cmd.execute()
      .then ->
        done()

  it "should send wait for the connection to end", (done) ->
    conn = new MockConnection
    cmd = new RootCommand conn
    ended = false
    conn.socket.on 'write', (chunk) ->
      expect(chunk.toString()).to.equal \
        Protocol.encodeData('root:').toString()
    setImmediate ->
      conn.socket.causeRead Protocol.OKAY
    setImmediate ->
      ended = true
      conn.socket.causeEnd()
    cmd.execute()
      .then ->
        expect(ended).to.be.true
        done()

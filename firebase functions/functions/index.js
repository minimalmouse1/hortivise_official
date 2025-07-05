const functions = require("firebase-functions");
const firebase = require("firebase-admin");
const StreamChat = require('stream-chat').StreamChat;
const api_key = '5zddj9r7ck27';
const api_secret = 'bddyd38x2pr355zn6b78pr4u4e26qe8udk559r3dc2rmwurb3ybza73bcp9e5d8z';

const serverClient = StreamChat.getInstance(api_key, api_secret);
firebase.initializeApp()
var firestore = firebase.firestore()
exports.getStreamChatToken = functions.https.onCall(async (data, context) => {
    try {
        const token = serverClient.createToken(data.id);
        return token
    } catch (e) {
        return 'Error : ' + e.param
    }
});


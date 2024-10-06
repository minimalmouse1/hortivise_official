const functions = require("firebase-functions");
const firebase = require("firebase-admin");
const stripe = require('stripe')('sk_test_51JsYwVJo0i9TcQEHTCUOHytAX84Rd8QbnRBrTSmvAPaKkQmSxBqm9ARIVwR7kwJI1SbCuWp2uwb3KpjapdWXz9ff00AloPFG3a');
const StreamChat = require('stream-chat').StreamChat;
const api_key = '5zddj9r7ck27';
const api_secret = 'bddyd38x2pr355zn6b78pr4u4e26qe8udk559r3dc2rmwurb3ybza73bcp9e5d8z';

const adminStripeAcconunt = 'acct_1Pd4LKR4gc0I5CMc'
const serverClient = StreamChat.getInstance(api_key, api_secret);
firebase.initializeApp()
var firestore = firebase.firestore()

exports.scheduledFunction = functions.pubsub.schedule('* * * * *').onRun(async (context) => {
    const consultations = firestore.collection('Consultations');
    const snapshot = await consultations.where('status', '==', 'accepted').get();
    if (snapshot.empty) {
        console.log('No matching documents.');
        return;
    }

    snapshot.forEach(async doc => {
        var startTime = doc.data().startTime.toDate().getTime()
        var endTime = doc.data().endTime.toDate().getTime()
        //  const currentDate = new Date(new Date().toUTCString())

        // await firestore.collection('date').add({ 'currentTime': currentDate, 'startTime': doc.data().startTime.toDate(), 'endTime': doc.data().endTime.toDate() })

        var doUpdate = getDifference(startTime, endTime)
        //console.log('Is Enable', '=>', doUpdate);
        if (doc.data().isEnabled != doUpdate) {
            doc.ref.update({ isEnabled: doUpdate })
        }
    })
    console.log('This will be run every 5 minutes!');
    return null;
});

function getDifference(timestamp1, timestamp2) {
    const currentDate = new Date(new Date().toUTCString())
    const timestamp = currentDate.getTime();

    if (timestamp >= timestamp1 && timestamp <= timestamp2) {
        return true;
    }
    else {
        return false;
    }

}


exports.createUser = functions.https.onCall(async (data, context) => {
    try {
        userEmail = data.email

        const account = await stripe.accounts.create({
            type: 'express',
            country: 'US',
            email: userEmail,
            business_type: 'individual',
        });
        return account.id;
    } catch (e) {
        return 'Error : ' + e.param
    }
});


// exports.createConsultantAccount = functions.https.onCall(async (data, context) => {
//     try {
//         const account = await stripe.accounts.create({
//             type: 'express',
//             email: data.email,
//             business_type: 'individual',
//             country: data.country,
//             capabilities: {
//                 card_payments: {
//                     requested: true,
//                 },
//                 transfers: {
//                     requested: true,
//                 },
//             },
//             external_account: {
//                 object: 'bank_account',
//                 country: data.country,
//                 currency: 'USD',
//                 account_holder_name: data.bankAccountName,
//                 account_holder_type: 'individual',
//                 routing_number: data.shortCode,
//                 account_number: data.accountNumber,
//             },
//             business_profile: {
//                 mcc: '0763',
//                 name: 'Consultant  :' + data.firtName,
//                 product_description: 'I am a Consultant',
//             },
//             individual: {
//                 address: {
//                     city: data.city,
//                     country: data.country,
//                     line1: data.address,
//                     postal_code: data.postalCode,
//                     state: null
//                 },
//                 dob: {
//                     day: data.day,
//                     month: data.month,
//                     year: data.year,
//                 },
//                 phone: data.phone,
//                 first_name: data.firtName,
//                 last_name: data.lastName,
//                 email: data.email,
//             },
//         });

//         return account.id;
//     } catch (e) {
//         return 'Error : ' + e.param
//     }
// });


exports.getAccountUrl = functions.https.onCall(async (data, context) => {
    try {
        userId = data.id;
        const accountLink = await stripe.accountLinks.create({
            account: userId,
            refresh_url: 'https://www.Hortivise.com/app',
            return_url: 'https://www.Hortivise.com/app',
            type: 'account_onboarding',
        });
        url = accountLink.url;
        console.log(url)
        return url;
    } catch (e) {
        return 'Error : ' + e.param
    }
});

exports.getAccountDetails = functions.https.onCall(async (data, context) => {
    try {
        accountId = data.id;
        const account = await stripe.accounts.retrieve(
            accountId
        );
        return account;
    } catch (e) {
        return 'Error : ' + e.param
    }
});

exports.transferAmmount = functions.https.onCall(async (data, context) => {
    try {
        accountId = data.id;
        amount = data.amount;
        const transfer = await stripe.transfers.create({
            amount: amount,
            currency: 'US',
            destination: accountId,
        });

        return transfer;
    } catch (e) {
        return 'Error : ' + e.param
    }
});

exports.getTransactionDetails = functions.https.onCall(async (data, context) => {
    try {
        transactionId = data.id;
        const balanceTransaction = await stripe.balanceTransactions.retrieve(
            transactionId
        );
        return balanceTransaction;
    } catch (e) {
        return 'Error : ' + e.param
    }
});

exports.getTransferDetails = functions.https.onCall(async (data, context) => {
    try {
        transferId = data.id;
        const transfer = await stripe.transfers.retrieve(
            transferId
        );
        return transfer;
    } catch (e) {
        return 'Error : ' + e.param
    }
});

exports.uplaodConsultionData = functions.https.onCall(async (d, context) => {
    try {
        paymentId = d.id;
        consultantStripeId = d.consultantStripeId
        consultationId = d.consultationId
        fromUserId = d.fromUserId
        date = d.date
        title = d.title
        customer = d.customer
        const paymentIntent = await stripe.paymentIntents.retrieve(
            paymentId
        );
        const charge = await stripe.charges.retrieve(
            paymentIntent.latest_charge
        );
        const balanceTransaction = await stripe.balanceTransactions.retrieve(
            charge.balance_transaction
        );
        data = {}
        data['paymentId'] = '';
        data['transactionStripeId'] = balanceTransaction.id;
        data['paymentIntentId'] = paymentId;
        data['amount'] = balanceTransaction.amount / 100;
        data['stripeFee'] = balanceTransaction.fee / 100;
        data['netAmount'] = balanceTransaction.net / 100;
        data['exchangeRate'] = balanceTransaction.exchange_rate;
        data['toStripeId'] = consultantStripeId;
        data['fromUserId'] = fromUserId;
        data['customer'] = customer;
        data['title'] = title;
        data['date'] = firebase.firestore.Timestamp.fromDate(new Date());;
        data['consultationId'] = consultationId;
        await firestore.collection('Paymnets').add(data).then((val) => {
            val.update({ 'paymentId': val.id })
        })
    } catch (e) {
        return 'Error : ' + e.param
    }
});

exports.getStreamChatToken = functions.https.onCall(async (data, context) => {
    try {
        const token = serverClient.createToken(data.id);
        return token
    } catch (e) {
        return 'Error : ' + e.param
    }
});


exports.distribution = functions.firestore.document('Paymnets/{paymentId}')
    .onCreate((snap, context) => {
        return requestRef.get().then((snapshot) => {

        })
    });


exports.getAccountStatus = functions.https.onCall(async (data, context) => {
    try {
        const id = data.id
        const account = await stripe.accounts.retrieve(
            id
        );
        if (account.payouts_enabled && account.charges_enabled) {
            return 'enabled'
        }
        else if (account.external_accounts.data == 0 || account.requirements.past_due != 0 || account.future_requirements.past_due != 0) {
            return 'incomplete'
        }
        else if (account.requirements.pending_verification != 0 || account.future_requirements.pending_verification != 0 || account.external_accounts.data[0].requirements.pending_verification != 0 || account.external_accounts.data[0].future_requirements.pending_verification == 0) {
            return 'pending'
        }
        else {
            return 'restricted'
        }
    } catch (e) {
        if (e.toString().includes('account does not exist')) {
            return 'Account not Exist'
        }
        else {
            return 'Error : ' + e.param
        }

    }
});

exports.scheduledFunctionStripeStatus = functions.pubsub.schedule(' */5 * * * *').onRun(async (context) => {
    const consultations = firestore.collection('Users');
    const snapshot = await consultations.where('specialist', '!=', null).get();
    if (snapshot.empty) {
        return;
    }

    snapshot.forEach(async doc => {
        var specialistData = doc.data().specialist
        var id = specialistData.stripeId
        try {
            var status = await findStripeStatus(id);

            if (status == 'enabled') {
                specialistData['isStripeActive'] = true
            }
            specialistData['status'] = status
            console.log(JSON.stringify(specialistData, null, 3))
            doc.ref.update({ specialist: specialistData })
        } catch (e) {
            if (e.toString().includes('account does not exist')) {
                return 'Account not Exist'
            }
            else {
                return 'Error : ' + e.param
            }
        }

    })
    return null;
});

async function findStripeStatus(id) {
    try {
        const account = await stripe.accounts.retrieve(
            id
        );
        if (account.payouts_enabled && account.charges_enabled) {
            return 'enabled'
        }
        else if (account.external_accounts.data == 0 || account.requirements.past_due != 0 || account.future_requirements.past_due != 0) {
            return 'incomplete'
        }
        else if (account.requirements.pending_verification != 0 || account.future_requirements.pending_verification != 0 || account.external_accounts.data[0].requirements.pending_verification != 0 || account.external_accounts.data[0].future_requirements.pending_verification == 0) {
            return 'pending'
        }
        else {
            return 'restricted'
        }
    } catch (e) {
        if (e.toString().includes('account does not exist')) {
            return 'Account not Exist'
        }
        else {
            return 'Error : ' + e.param
        }

    }





}

exports.transferData = functions.pubsub.schedule('every 60 minutes').onRun(async (context) => {
    const abc = firestore.collection('Paymnets');
    var snapshot = await abc.orderBy('date').get();
    if (snapshot.empty) {
        return;
    }

    snapshot.forEach(async doc => {
        try {
            const balance = await stripe.balance.retrieve();
            var bal = balance.available[0].amount / 100
            var data = doc.data()
            var ammount = data.netAmount
            if (bal < ammount) {
                return
            }
            var businessStripeId = data.toStripeId
            var businessammount = (ammount * 80) / 100
            var ownerAccount = ammount - businessammount
            ownerAccount = ownerAccount.toFixed(2)
            businessammount = businessammount.toFixed(2)
            var id = await transferAmmount({ 'id': businessStripeId, 'amount': parseInt(businessammount * 100) })

            var businessData = {
                stripeId: businessStripeId,
                ammount: businessammount,
                title: data.title,
                customer: data.customer,
                businessUID: data.fromUserId,
                transferId: id.id,
                date: data.date
            }
            id = await transferAmmount({ 'id': adminConnectAccount, 'amount': parseInt(ownerAccount * 100) })
            var adminData = {
                stripeId: adminConnectAccount,
                ammount: ownerAccount,
                transferId: id.id
            }
            await firestore.collection('Transfers').add({
                business: businessData,
                hortivige: adminData,
                paymentId: data.paymentId,
                transactionId: data.transactionStripeId,
                netAmmount: data.amount,
                paymentIntentId: data.paymentIntentId
            })
            await doc.ref.delete()
        } catch (e) {
            if (e.toString().includes('account does not exist')) {
                return 'Account not Exist'
            }
            else {
                return 'Error : ' + e
            }
        }

    })
    return null;
});
module.exports = {
    async up(db, client) {
        const senderAuth = db.collection("senderauth");

        const renameResult = await senderAuth.updateMany(
            {},
            {$rename: {'senderCode': 'senderCodes'}}, // rename field
            {writeConcern: 'majority'}
        );
        console.log(`Renamed field on ${renameResult.modifiedCount} documents`);

        // this update should be done by an aggregation pipeline update, but it's supported on mongo 4.2
        const docs = await senderAuth.find().map(item => item).toArray();
        for (const doc of docs) {
            const updateResult = await senderAuth.updateOne(
                {apiKey: doc.apiKey},
                {$set: {'senderCodes': [doc.senderCodes]}},
                {writeConcern: 'majority'}
            );
            console.log(`Update senderCode type ${updateResult.apiKey}`);
        }
    },

    async down(db, client) {
        // TODO write the statements to rollback your migration (if possible)
        // Example:
        // await db.collection('albums').updateOne({artist: 'The Beatles'}, {$set: {blacklisted: false}});
    }
};

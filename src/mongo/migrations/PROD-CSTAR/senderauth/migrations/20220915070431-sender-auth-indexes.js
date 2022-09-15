// This migration scripts makes a dump of sender auth before creating new indexes
// after indexes creation it restores the collection. This is caused by cosmos db which
// deny the creation of indexes over non-empty collections
module.exports = {
  async up(db, client) {
    const senderAuthCollection = db.collection("senderauth");
    const dump = await senderAuthCollection.find().map(item => item).toArray();
    console.log(`Found ${dump.length} documents`);
    const deleted = await senderAuthCollection.deleteMany({});
    console.log(`Deleted ${deleted.deletedCount} documents`);

    await senderAuthCollection.createIndex({ 'apiKey': 1 }, { unique: true });
    await senderAuthCollection.createIndex({ 'senderCodes': 1 });

    // restore collection
    const restored = await senderAuthCollection.insertMany(dump);
    console.log(`Restored ${restored.insertedCount} documents`);
  },

  async down(db, client) {}
};

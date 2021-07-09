db.createUser(
    {
      user: "fluentd",
      pwd: "fluentd@123",
      roles: [
         { role: "readWrite", db: "fluentd" }
      ]
    }
,
    {
        w: "majority",
        wtimeout: 5000
    }
);
db.createCollection("testUserFile");
// init-mongo.js
db.getSiblingDB('admin').createUser({
    user: "admin",
    pwd: "adminPassword",  // Replace with a secure password
    roles: [{ role: "userAdminAnyDatabase", db: "admin" }]
});

db.getSiblingDB('pacman').createUser({
    user: "pacman",
    pwd: "pacman",  // Replace with a secure password
    roles: [{ role: "readWrite", db: "pacman" }]
});

db.getSiblingDB('pacman').createCollection("init");
db.getSiblingDB('pacman').init.insert({name: "init"});

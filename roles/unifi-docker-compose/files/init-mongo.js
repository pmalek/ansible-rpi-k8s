print('Start #################################################################');
db.getSiblingDB("unifi").createUser({user: "unifi", pwd: "k7xtNGKkELUKg4xz", roles: [{role: "dbOwner", db: "unifi"}]});
db.getSiblingDB("unifi_stat").createUser({user: "unifi", pwd: "k7xtNGKkELUKg4xz", roles: [{role: "dbOwner", db: "unifi_stat"}]});
print('End #################################################################');
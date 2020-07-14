<?php
$CONFIG = array (
// url of a custom lookup server to publish user data	
'lookup_server' => getenv('LOOKUP_SERVER'),

// can be chosen freely, you just have to make sure the master and
// all slaves have the same key.  Also make sure to choose a strong shared secret.
'gss.jwt.key' => getenv('GSS_JWT_KEY'),

// operation mode
'gss.mode' => getenv('GSS_MODE'),

);

if (getenv('GSS_MODE')=='master') {
    $CONFIG = array (
    // define a master admins, this users will not be redirected to a slave but are
    // allowed to login at the master node to perform administration tasks
    'gss.master.admin' => [ getenv('GSS_MASTER_ADMIN') ],

    // define a class which will be used to decide on which server a user should be
    // provisioned in case the lookup server doesn't know the user yet.
    // Note: That this will create a user account on a global scale note for every user
    //       so make sure that the Global Site Selector has verified if it is a valid user before.
    //       The user disovery module might require additional config paramters you can find in
    //       the documentation of the module
    'gss.user.discovery.module' => '\OCA\GlobalSiteSelector\UserDiscoveryModules\UserDiscoverySAML',
    );
} else if (getenv('GSS_MODE')=='slave') {
    $CONFIG = array (
    // url of the master, so we can redirect the user back in case of an error
    'gss.master.url' => getenv('GSS_MASTER_URL'),
    );
}


<?php
$CONFIG = array (
  'objectstore' => array(
    'class' => '\\OC\\Files\\ObjectStore\\S3',
    'arguments' => array(
      'bucket'         => getenv('S3_BUCKET'),
      'autocreate'     => true,
      'key'            => getenv('S3_KEY'),
      'secret'         => getenv('S3_SECRET'),
      'hostname'       => getenv('S3_HOSTNAME'),
      'use_ssl'        => true,
      'use_path_style' => true
    )
  )
);

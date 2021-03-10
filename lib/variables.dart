Map env = const {
   'POST_URL': 'http://localhost:5379/posts',
   'SCHEDULE_URL': 'http://localhost:5379/schedule-post',
   'BATCH_DELETE_URL': 'http://localhost:5379/batch-delete',
   'LOGIN_URL': 'http://localhost:3576/login',
   'SIGNUP_URL': 'http://localhost:3576/signup',
   'VALIDATE_TOKEN_URL': 'http://localhost:3576/validate',
   'FACEBOOK_URL': 'http://localhost:5379/fb/code',
   'POST_COUNT_URL': 'http://localhost:5379/count/post',
   'SCHEDULE_COUNT_URL': 'http://localhost:5379/count/schedule',
   'SCHEDULE_STATUS_WEBSOCKET': 'ws://localhost:5379/pws/schedule-status',
   'MEDIA_UPLOAD_URL': 'http://localhost:5379/file/upload'
};
const base_url = 'postit-backend-api.herokuapp.com';
const base_auth_url = 'postit-auth.herokuapp.com';
/*Map env = const {
 'POST_URL': 'https://$base_url/posts',
 'SCHEDULE_URL': 'https://$base_url/schedule-post',
 'BATCH_DELETE_URL': 'https://$base_url/batch-delete',
 'LOGIN_URL': 'https://$base_auth_url/login',
 'SIGNUP_URL': 'https://$base_auth_url/signup',
 'VALIDATE_TOKEN_URL': 'https://$base_auth_url/validate',
 'FACEBOOK_URL': 'https://$base_url/fb/code',
 'DELETE_FACEBOOK_ACCOUNT_URL': 'https://$base_url/fb/code',
 'COUNT_URL': 'https://$base_url/count/data',
 'SCHEDULE_STATUS_WEBSOCKET': 'wss://$base_url/pws/schedule-status',
 'MEDIA_UPLOAD_URL': 'https://$base_url/file/upload'
};*/

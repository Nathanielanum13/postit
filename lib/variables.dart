//development
 const base_url = 'http://localhost:5379';
 const base_auth_url = 'http://localhost:3576';
 const web_socket_url = 'ws://localhost:5379';

//production
//const base_url = 'https://postit-dev-api.herokuapp.com';
//const base_auth_url = 'https://postit-dev-auth.herokuapp.com';
//const web_socket_url = 'wss://postit-dev-api.herokuapp.com';


Map env = const {
 'POST_URL': '$base_url/posts',
 'SCHEDULE_URL': '$base_url/schedule-post',
 'BATCH_DELETE_URL': '$base_url/batch-delete',
 'LOGIN_URL': '$base_auth_url/login',
 'SIGNUP_URL': '$base_auth_url/signup',
 'VALIDATE_TOKEN_URL': '$base_auth_url/validate',
 'FACEBOOK_LOGIN_URL': '$base_url/fb/code',
 'ALL_ACCOUNTS_URL': '$base_url/all/code',
 'DELETE_FACEBOOK_ACCOUNT_URL': '$base_url/fb/code',
 'COUNT_URL': '$base_url/count/data',
 'SCHEDULE_STATUS_WEBSOCKET': '$web_socket_url/pws/schedule-status',
 'MEDIA_UPLOAD_URL': '$base_url/file/upload',
 'PROFILE_URL': '$base_auth_url/auth/profile',
 'LOGIN_PASSWORD': '$base_auth_url/auth/password',
 'COMPANY_DETAIL': '$base_auth_url/auth/details'
};

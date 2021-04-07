/*const base_url = 'localhost:5379';
const base_auth_url = 'localhost:3576';
Map env = const {
  'POST_URL': 'http://$base_url/posts',
  'SCHEDULE_URL': 'http://$base_url/schedule-post',
  'BATCH_DELETE_URL': 'http://$base_url/batch-delete',
  'LOGIN_URL': 'http://$base_auth_url/login',
  'SIGNUP_URL': 'http://$base_auth_url/signup',
  'VALIDATE_TOKEN_URL': 'http://$base_auth_url/validate',
  'FACEBOOK_URL': 'http://$base_url/fb/code',
  'DELETE_FACEBOOK_ACCOUNT_URL': 'http://$base_url/fb/code',
  'COUNT_URL': 'http://$base_url/count/data',
  'SCHEDULE_STATUS_WEBSOCKET': 'ws://$base_url/pws/schedule-status',
  'MEDIA_UPLOAD_URL': 'http://$base_url/file/upload',
  'PROFILE_URL': 'http://$base_auth_url/auth/profile',
  'LOGIN_PASSWORD': 'http://$base_auth_url/auth/password',
  'COMPANY_DETAIL': 'http://$base_auth_url/auth/details'
};*/
const base_url = 'postit-dev-api.herokuapp.com';
const base_auth_url = 'postit-dev-auth.herokuapp.com';
Map env = const {
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
  'MEDIA_UPLOAD_URL': 'https://$base_url/file/upload',
  'PROFILE_URL': 'https://$base_auth_url/auth/profile',
  'LOGIN_PASSWORD': 'https://$base_auth_url/auth/password',
  'COMPANY_DETAIL': 'https://$base_auth_url/auth/details'
};

const isProd = bool.fromEnvironment('prod');

const base_url = isProd ? 'https://postit-prod-api.herokuapp.com' : 'https://add0-154-161-37-203.ngrok-free.app';
const base_auth_url = isProd ? 'https://postit-prod-auth.herokuapp.com' : 'https://3d90-154-161-40-36.ngrok-free.app';
const websocket_url = isProd ? 'wss://postit-prod-schedule-status.herokuapp.com' : 'ws://localhost:3567';

/*const base_url = String.fromEnvironment('baseUrl', defaultValue: 'http://localhost:5379');
const base_auth_url = String.fromEnvironment('baseAuthUrl', defaultValue: 'http://localhost:3576');
const websocket_url = String.fromEnvironment('websocketUrl', defaultValue: 'ws://localhost:3567');*/

Map env = const {
 'POST_URL': '$base_url/posts',
 'SCHEDULE_URL': '$base_url/schedule-post',
 'BATCH_DELETE_URL': '$base_url/batch-delete',
 'LOGIN_URL': '$base_auth_url/login',
 'SIGNUP_URL': '$base_auth_url/signup',
 'VALIDATE_TOKEN_URL': '$base_auth_url/validate',
 'FACEBOOK_URL': '$base_url/fb/code',
 'FACEBOOK_POST_URL': '$base_url/fb/posts',
 'DELETE_FACEBOOK_ACCOUNT_URL': '$base_url/fb/code',
 'ALL_ACCOUNTS_URL': '$base_url/all/code',
 'COUNT_URL': '$base_url/count/data',
 'SCHEDULE_STATUS_WEBSOCKET': '$websocket_url/pws/schedule-status',
 'MEDIA_UPLOAD_URL': '$base_url/file/upload',
 'MEDIA_BATCH_UPLOAD_URL': '$base_url/delete/all',
 'PROFILE_URL': '$base_auth_url/auth/profile',
 'LOGIN_PASSWORD': '$base_auth_url/auth/password',
 'COMPANY_DETAIL': '$base_auth_url/auth/details'
};

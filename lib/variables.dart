/*Map env = const {
   'POST_URL': 'http://localhost:5379/posts',
   'SCHEDULE_URL': 'http://localhost:5379/schedule-post',
   'BATCH_DELETE_URL': 'http://localhost:5379/batch-delete',
   'LOGIN_URL': 'http://localhost:3576/login',
   'SIGNUP_URL': 'http://localhost:3576/signup',
   'VALIDATE_TOKEN_URL': 'http://localhost:3576/validate',
   'FACEBOOK_URL': 'http://localhost:5379/fb/code',
   'POST_COUNT_URL': 'http://localhost:5379/count/post',
   'SCHEDULE_COUNT_URL': 'http://localhost:5379/count/schedule',
   'SCHEDULE_STATUS_WEBSOCKET': 'ws://localhost:5379/pws/schedule-status'
};*/

Map env = const {
 'POST_URL': 'https://postit-backend-api.herokuapp.com/posts',
 'SCHEDULE_URL': 'https://postit-backend-api.herokuapp.com/schedule-post',
 'BATCH_DELETE_URL': 'https://postit-backend-api.herokuapp.com/batch-delete',
 'LOGIN_URL': 'https://postit-auth.herokuapp.com/login',
 'SIGNUP_URL': 'https://postit-auth.herokuapp.com/signup',
 'VALIDATE_TOKEN_URL': 'https://postit-auth.herokuapp.com/validate',
 'FACEBOOK_URL': 'https://postit-backend-api.herokuapp.com/fb/code',
 'DELETE_FACEBOOK_ACCOUNT_URL': 'https://postit-backend-api.herokuapp.com/fb/code',
 'COUNT_URL': 'https://postit-backend-api.herokuapp.com/count/data',
 'SCHEDULE_STATUS_WEBSOCKET': 'wss://postit-backend-api.herokuapp.com/pws/schedule-status',
};

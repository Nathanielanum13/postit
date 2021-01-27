/*Map env = const {
   'POST_URL': 'http://localhost:5379/posts',
   'SCHEDULE_URL': 'http://localhost:5379/schedule-post',
   'BATCH_DELETE_URL': 'http://localhost:5379/batch-delete',
   'LOGIN_URL': 'http://localhost:3576/login',
   'SIGNUP_URL': 'http://localhost:3576/signup',
   'VALIDATE_TOKEN_URL': 'http://localhost:3576/validate',
   'FACEBOOK_URL': 'http://localhost:5379/fb/code'
};*/

Map env = const {
 'POST_URL': 'https://postit-backend-api.herokuapp.com/posts',
 'SCHEDULE_URL': 'https://postit-backend-api.herokuapp.com/schedule-post',
 'BATCH_DELETE_URL': 'https://postit-backend-api.herokuapp.com/batch-delete',
 'LOGIN_URL': 'https://postit-auth.herokuapp.com/login',
 'SIGNUP_URL': 'https://postit-auth.herokuapp.com/signup',
 'VALIDATE_TOKEN_URL': 'https://postit-auth.herokuapp.com/validate',
 'FACEBOOK_URL': 'https://postit-backend-api.herokuapp.com/fb/code',
 'POST_COUNT_URL': 'https://postit-backend-api.herokuapp.com/count/post',
 'SCHEDULE_COUNT_URL': 'https://postit-backend-api.herokuapp.com/count/schedule',
 'SCHEDULE_STATUS_WEBSOCKET': 'postit-backend-api.herokuapp.com/pws/schedule-status'
};

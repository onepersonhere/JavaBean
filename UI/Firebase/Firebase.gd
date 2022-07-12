extends Node
var PrivateKey = load("res://UI/Firebase/PrivateKey.gd")
const PROJECT_ID = "javabean-1"

var login_url = "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=" + PrivateKey.API_KEY
var register_url = "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=" + PrivateKey.API_KEY
const FIRESTORE_URL = "https://firestore.googleapis.com/v1/projects/%s/databases/(default)/documents/" % PROJECT_ID
# TODO: associate player's NFT address to the account
var user_info = {
	"token": "",
	"id": ""
}

func get_user_info(result: Array) -> Dictionary:
	var result_body = JSON.parse(result[3].get_string_from_ascii()).result as Dictionary
	return {
		"token": result_body.idToken,
		"id": result_body.localId
	}

func get_req_headers() -> PoolStringArray:
	return PoolStringArray([
		"Content-Type: application/json",
		"Authorization: Bearer %s" % user_info.token
	])

func register(email:String, password: String, http: HTTPRequest) -> void:
	var body = {
		"email": email,
		"password": password,
	}
	
	http.request(register_url, [], false, HTTPClient.METHOD_POST, to_json(body))
	
	var result = yield(http, "request_completed") as Array
	if result[1] == 200:
		user_info = get_user_info(result)

func login(email:String, password: String, http: HTTPRequest) -> void:
	var body = {
		"email": email,
		"password": password,
		"returnSecureToken": true
	}
	
	http.request(login_url, [], false, HTTPClient.METHOD_POST, to_json(body))
	
	var result = yield(http, "request_completed") as Array
	if (result[1] == 200):
		user_info = get_user_info(result)

func save_document(path: String, fields: Dictionary, http: HTTPRequest) -> void:
	var document = {"fields": fields}
	var body = to_json(document)
	var url = FIRESTORE_URL + path
	
	http.request(url, get_req_headers(), false, HTTPClient.METHOD_POST, body)
	
func get_document(path: String, http: HTTPRequest) -> void:
	var url = FIRESTORE_URL + path
	http.request(url, get_req_headers(), false, HTTPClient.METHOD_GET)

func update_document(path: String, fields: Dictionary, http: HTTPRequest) -> void:
	var document = {"fields": fields}
	var body = to_json(document)
	var url = FIRESTORE_URL + path
	
	http.request(url, get_req_headers(), false, HTTPClient.METHOD_PATCH, body)
	
func delete_document(path: String, http: HTTPRequest) -> void:
	var url = FIRESTORE_URL + path
	http.request(url, get_req_headers(), false, HTTPClient.METHOD_DELETE)

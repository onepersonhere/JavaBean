extends Node
var PrivateKey = load("res://UI/Firebase/PrivateKey.gd")
var login_url = "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=" + PrivateKey.API_KEY
var register_url = "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=" + PrivateKey.API_KEY

var curr_token = ""

func get_token_id(result: Array) -> String:
	var result_body = JSON.parse(result[3].get_string_from_ascii()).result as Dictionary
	return result_body.idToken

func register(email:String, password: String, http: HTTPRequest) -> void:
	var body = {
		"email": email,
		"password": password,
	}
	
	http.request(register_url, [], false, HTTPClient.METHOD_POST, to_json(body))
	
	var result = yield(http, "request_completed") as Array
	if result[1] == 200:
		curr_token = get_token_id(result)

func login(email:String, password: String, http: HTTPRequest) -> void:
	var body = {
		"email": email,
		"password": password,
	}
	
	http.request(login_url, [], false, HTTPClient.METHOD_POST, to_json(body))
	
	var result = yield(http, "request_completed") as Array
	if (result[1] == 200):
		curr_token = get_token_id(result)

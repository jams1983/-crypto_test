# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version
3.2.0

* Database creation
```bash
rails db:create db:migrate db:seed
```


* How to run the app
```bash
rails s
```


* ...

* Error intentando conectarme al servicio por websocket

```javascript
webSocket = new WebSocket("ws://ws.coinapi.io/v1/");
webSocket.onmessage = (event) => {
  console.log(event.data);
};

msg = {
  "type": "subscribe",
  "apikey": "3CE685E6-4EA9-4BE5-BEBA-1A625ED130AB",
  "heartbeat": true,
  "subscribe_data_type": ["exchange"],
  "subscribe_filter_asset_id": ["BTC", "ETH"]
}

webSocket.send(JSON.stringify(msg));

{
  "message":"Forbidden - Your API key don't have privileges to data type 'exchange'.",
  "type":"error"
}

```

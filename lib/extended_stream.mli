type json_stream = Json_stream.Extended.json

include (Reader_stream.Reader_stream with type json_stream := json_stream)
include (Writer_stream.Intf)

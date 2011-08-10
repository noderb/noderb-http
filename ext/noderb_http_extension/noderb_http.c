#include <noderb_http.h>

typedef struct {
    long parser;
    int pre_headers;
} nodeRb_http;

VALUE nodeRbHttpParser;
VALUE nodeRbHttpPointer;

VALUE nodeRb_get_object_from_id(long id) {
    return rb_funcall(rb_const_get(rb_cObject, rb_intern("ObjectSpace")), rb_intern("_id2ref"), 1, rb_int2inum(id));
}

int nodeRb_http_on_message_begin(http_parser* parser) {
    nodeRb_http* client = parser->data;
    VALUE self = nodeRb_get_object_from_id(client->parser);
    rb_funcall(self, rb_intern("on_message_begin"), 0);
    return 0;
}

int nodeRb_http_on_url(http_parser* parser, const char *buf, size_t len) {
    nodeRb_http* client = parser->data;
    VALUE self = nodeRb_get_object_from_id(client->parser);
    if(parser->type == HTTP_REQUEST){
        rb_funcall(self, rb_intern("on_method"), 1, rb_str_new2(http_method_str(parser->method)));
    }
    rb_funcall(self, rb_intern("on_url"), 1, rb_str_new(buf, len));
    return 0;
}

int nodeRb_http_on_header_field(http_parser* parser, const char *buf, size_t len) {
    nodeRb_http* client = parser->data;
    VALUE self = nodeRb_get_object_from_id(client->parser);
    rb_funcall(self, rb_intern("on_header_field"), 1, rb_str_new(buf, len));
    return 0;
}

int nodeRb_http_on_header_value(http_parser* parser, const char *buf, size_t len) {
    nodeRb_http* client = parser->data;
    VALUE self = nodeRb_get_object_from_id(client->parser);
    rb_funcall(self, rb_intern("on_header_value"), 1, rb_str_new(buf, len));
    return 0;
}

int nodeRb_http_on_headers_complete(http_parser* parser) {
    nodeRb_http* client = parser->data;
    VALUE self = nodeRb_get_object_from_id(client->parser);
    rb_funcall(self, rb_intern("on_version"), 2, rb_int2inum(parser->http_major), rb_int2inum(parser->http_minor));
    if(parser->type == HTTP_RESPONSE){
        rb_funcall(self, rb_intern("on_status_code"), 1, rb_int2inum(parser->status_code));
    }
    if (http_should_keep_alive(parser)) {       
        rb_funcall(self, rb_intern("on_keep_alive"), 1, Qtrue);
    }
    rb_funcall(self, rb_intern("on_headers_complete"), 0);
    return 0;
}

int nodeRb_http_on_body(http_parser* parser, const char *buf, size_t len) {
    nodeRb_http* client = parser->data;
    VALUE self = nodeRb_get_object_from_id(client->parser);
    rb_funcall(self, rb_intern("on_body"), 1, rb_str_new(buf, len));
    return 0;
}

int nodeRb_http_on_message_complete(http_parser* parser) {
    nodeRb_http* client = parser->data;
    VALUE self = nodeRb_get_object_from_id(client->parser);
    rb_funcall(self, rb_intern("on_message_complete"), 0);
    return 0;
}

VALUE nodeRb_http_setup(VALUE self, VALUE type) {
    http_parser_settings* settings = malloc(sizeof (http_parser_settings));

    settings->on_message_begin = nodeRb_http_on_message_begin;
    
    settings->on_url = nodeRb_http_on_url;

    settings->on_header_field = nodeRb_http_on_header_field;
    settings->on_header_value = nodeRb_http_on_header_value;

    settings->on_headers_complete = nodeRb_http_on_headers_complete;
        
    settings->on_body = nodeRb_http_on_body;

    settings->on_message_complete = nodeRb_http_on_message_complete;

    http_parser* parser = malloc(sizeof (http_parser));
    
    if(ID2SYM(rb_intern("response")) == type){
        http_parser_init(parser, HTTP_RESPONSE);
    }else{
        http_parser_init(parser, HTTP_REQUEST);
    }   

    nodeRb_http* client = malloc(sizeof (nodeRb_http));
    parser->data = client;

    client->parser = rb_num2long(rb_obj_id(self));

    rb_iv_set(self, "@settings", Data_Wrap_Struct(nodeRbHttpPointer, 0, NULL, settings));
    rb_iv_set(self, "@parser", Data_Wrap_Struct(nodeRbHttpPointer, 0, NULL, parser));
};

VALUE nodeRb_http_parse(VALUE self, VALUE data) {

    http_parser_settings* settings;
    http_parser* parser;

    VALUE rsettings = rb_iv_get(self, "@settings");
    VALUE rparser = rb_iv_get(self, "@parser");


    Data_Get_Struct(rsettings, http_parser_settings, settings);
    Data_Get_Struct(rparser, http_parser, parser);

    nodeRb_http* client = parser->data;

    size_t parsed = http_parser_execute(parser, settings, rb_string_value_cstr(&data), RSTRING_LEN(data));

    if (parser->upgrade) {
        rb_funcall(self, rb_intern("on_upgrade"), 0);
    } else if (parsed != (unsigned) RSTRING_LEN(data)) {
        rb_funcall(self, rb_intern("on_error"), 2, rb_str_new2(http_errno_name(parser->http_errno)), rb_str_new2(http_errno_description(parser->http_errno)));
    };
};

VALUE nodeRb_http_dispose(VALUE self) {
    http_parser_settings* settings;
    http_parser* parser;

    Data_Get_Struct(rb_iv_get(self, "@settings"), http_parser_settings, settings);
    Data_Get_Struct(rb_iv_get(self, "@parser"), http_parser, parser);

    free(parser->data);
    free(settings);
    free(parser);
};

void Init_noderb_http_extension() {
    // Define module
    VALUE nodeRb = rb_define_module("NodeRb");
    // Modules
    VALUE nodeRbModules = rb_define_module_under(nodeRb, "Modules");
    // Http
    VALUE nodeRbHttp = rb_define_module_under(nodeRbModules, "Http");
    // Http parser
    nodeRbHttpPointer = rb_define_class_under(nodeRbHttp, "Pointer", rb_cObject);
    nodeRbHttpParser = rb_define_module_under(nodeRbHttp, "Parser");
    // Methods
    rb_define_method(nodeRbHttpParser, "setup", nodeRb_http_setup, 1);
    rb_define_method(nodeRbHttpParser, "parse", nodeRb_http_parse, 1);
    rb_define_method(nodeRbHttpParser, "dispose", nodeRb_http_dispose, 0);
}
import 'package:universal_html/html.dart' as html;


const String sessionKey = 'session';

void save_session(String? session) {
  if (session == null) {
    html.window.localStorage.remove(sessionKey);
    return;
  }
  html.window.localStorage[sessionKey] = session;
}

String get_session() {
  return html.window.localStorage[sessionKey] ?? '';
}

// vim: set ts=2 sw=2 expandtab:

import '../general/constants/app_image.dart';

class Const {
  static const int kReportAction = -1;
  static const int kNopeAction = 1;
  static const int kLikeAction = 2;
  static const int kSuperLikeAction = 3;
  static const int kSettingMinAgeRange = 18;
  static const int kSettingMaxAgeRange = 70;
  static const double kSettingMinDistance = 1;
  static const double kSettingMaxDistance = 150;
  static const int kMaxImageNumber = 6;
  static const int kNumberOfImagesRequired = 2;

  static const int kVerifyAccountRejected = -1;
  static const int kVerifyAccountNewly = 0;
  static const int kVerifyAccountPending = 1;
  static const int kVerifyAccountSuccess = 2;

  static const int kCustomerMaxPercentAvatars = 33;
  static const int kCustomerMaxPercentAbout = 20;
  static const int kCustomerMaxPercentInterests = 15;
  static const int kCustomerMaxPercentDatingPurpose = 4;
  static const int kCustomerMaxPercentLanguages = 4;
  static const int kCustomerMaxPercentBasics = 4;
  static const int kCustomerMaxPercentLifestyle = 4;
  static const int kCustomerMaxPercentJobTitle = 4;
  static const int kCustomerMaxPercentCompany = 4;
  static const int kCustomerMaxPercentSchool = 4;
  static const int kCustomerMaxPercentAddress = 4;

  static const String kUrlHelpAndSupport = "https://www.google.com/";
  static const String kUrlCommunityGuidelines = "https://www.google.com/";
  static const String kUrlSafetyTip = "https://www.google.com/";
  static const String kUrlSafetyCenter = "https://www.google.com/";
  static const String kUrlGuideLines = "https://www.google.com/";
  static const String kUrlTermOfService = "https://meloha.com/term-of-service";
  static const String kUrlPrivacyPolicy = "https://meloha.com/policy";
  static const String kUrlCookiesPolicy = "https://www.google.com/";
  static const String kUrlDateSafetyGuidelines = "https://www.google.com/";
  static const String kUrlPhonesChangesPolicy = "https://www.google.com/";

  static const String kDistTypeKm = "km";
  static const String kDistTypeMiles = "miles";

  static const String deletedAccount = "_deleted_account";
  static const String defaultHashImage = "L5H2EC=PM+yV0g-mq.wG9c010J}I";
  static const String melohaID = "01HXTG29F6GRAT7EFBDTR67XYB";
  static const String appName = "Meloha";

  static const String kVerifyEmail = "kVerifyEmail";

  static const String fbKeyEnsc = "BachaSoft2023!#@BachaSoft2024!#@";
  static const String fbIVEnsc = "BachaSoft2023!#@";

  static const List<String> blacklistNames = ['meloha', 'about', 'academic-honesty', 'account', 'agile', 'all-stories', 'api', 'backend-challenge-completed', 'blocked', 'bonfire', 'cats.json', 'challenge-completed', 'challenge', 'challenges', 'chat', 'code-of-conduct', 'coding-bootcamp-cost-calculator', 'completed-bonfire', 'completed-challenge', 'completed-field-guide', 'completed-jsProject', 'completed-zipline-or-basejump', 'copyright-policy', 'copyright', 'deprecated-signin', 'donate', 'email-signin', 'events', 'exam', 'explorer', 'external', 'field-guide', 'forgot', 'forum', 'freecodecamp', 'get-help', 'get-pai', 'guide', 'how-nonprofit-projects-work', 'internal', 'jobs-form', 'jobs', 'jsProject', 'learn-to-code', 'learn', 'login', 'logout', 'map', 'modern-challenge-completed', 'news', 'nonprofit-project-instructions', 'nonprofits-form', 'nonprofits', 'open-api', 'passwordless-change', 'pmi-acp-agile-project-managers-form', 'pmi-acp-agile-project-managers', 'privacy-policy', 'privacy', 'profile', 'project-completed', 'reset', 'services', 'shop', 'signin', 'signout', 'signup', 'sitemap.xml', 'software-resources-for-nonprofits', 'sponsors', 'stories', 'support', 'terms-of-service', 'terms', 'the-fastest-web-page-on-the-internet', 'twitch', 'unsubscribe', 'unsubscribed', 'update-my-honesty', 'update-my-portfolio', 'update-my-profile-ui', 'update-my-quincy-email', 'update-my-socials', 'update-my-sound', 'update-my-theme', 'update-my-keyboard-shortcuts', 'update-my-username', 'user', 'username', 'wiki', '.htaccess', '.htpasswd', '.well-known', '400', '401', '403', '404', '405', '406', '407', '408', '409', '410', '411', '412', '413', '414', '415', '416', '417', '421', '422', '423', '424', '426', '428', '429', '431', '500', '501', '502', '503', '504', '505', '506', '507', '508', '509', '510', '511', 'about-us', 'abuse', 'access', 'accounts', 'ad', 'add', 'admin', 'administration', 'administrator', 'ads', 'advertise', 'advertising', 'aes128-ctr', 'aes128-gcm', 'aes192-ctr', 'aes256-ctr', 'aes256-gcm', 'affiliate', 'affiliates', 'ajax', 'alert', 'alerts', 'alpha', 'amp', 'analytics', 'app', 'apps', 'asc', 'assets', 'atom', 'auth', 'authentication', 'authorize', 'autoconfig', 'autodiscover', 'avatar', 'backup', 'banner', 'banners', 'beta', 'billing', 'billings', 'blog', 'blogs', 'board', 'bookmark', 'bookmarks', 'broadcasthost', 'business', 'buy', 'cache', 'calendar', 'campaign', 'captcha', 'careers', 'cart', 'cas', 'categories', 'category', 'cdn', 'cgi', 'cgi-bin', 'chacha20-poly1305', 'change', 'channel', 'channels', 'chart', 'checkout', 'clear', 'client', 'close', 'cms', 'com', 'comment', 'comments', 'community', 'compare', 'compose', 'config', 'connect', 'contact', 'contest', 'cookies', 'copy', 'count', 'create', 'crossdomain.xml', 'css', 'curve25519-sha256', 'customer', 'customers', 'customize', 'dashboard', 'db', 'deals', 'debug', 'delete', 'desc', 'destroy', 'dev', 'developer', 'developers', 'diffie-hellman-group-exchange-sha256', 'diffie-hellman-group14-sha1', 'disconnect', 'discuss', 'dns', 'dns0', 'dns1', 'dns2', 'dns3', 'dns4', 'docs', 'documentation', 'domain', 'download', 'downloads', 'downvote', 'draft', 'drop', 'ecdh-sha2-nistp256', 'ecdh-sha2-nistp384', 'ecdh-sha2-nistp521', 'edit', 'editor', 'email', 'enterprise', 'error', 'errors', 'event', 'example', 'exception', 'exit', 'explore', 'export', 'extensions', 'false', 'family', 'faq', 'faqs', 'favicon.ico', 'features', 'feed', 'feedback', 'feeds', 'file', 'files', 'filter', 'follow', 'follower', 'followers', 'following', 'fonts', 'forgot-password', 'forgotpassword', 'form', 'forms', 'forums', 'friend', 'friends', 'ftp', 'get', 'git', 'go', 'group', 'groups', 'guest', 'guidelines', 'guides', 'head', 'header', 'help', 'hide', 'hmac-sha', 'hmac-sha1', 'hmac-sha1-etm', 'hmac-sha2-256', 'hmac-sha2-256-etm', 'hmac-sha2-512', 'hmac-sha2-512-etm', 'home', 'host', 'hosting', 'hostmaster', 'htpasswd', 'http', 'httpd', 'https', 'humans.txt', 'icons', 'images', 'imap', 'img', 'import', 'index', 'info', 'insert', 'investors', 'invitations', 'invite', 'invites', 'invoice', 'is', 'isatap', 'issues', 'it', 'join', 'js', 'json', 'keybase.txt', 'legal', 'license', 'licensing', 'like', 'limit', 'live', 'load', 'local', 'localdomain', 'localhost', 'lock', 'lost-password', 'mail', 'mail0', 'mail1', 'mail2', 'mail3', 'mail4', 'mail5', 'mail6', 'mail7', 'mail8', 'mail9', 'mailer-daemon', 'mailerdaemon', 'marketing', 'marketplace', 'master', 'me', 'media', 'member', 'members', 'message', 'messages', 'metrics', 'mis', 'mobile', 'moderator', 'modify', 'more', 'mx', 'my', 'net', 'network', 'new', 'newsletter', 'newsletters', 'next', 'nil', 'no-reply', 'nobody', 'noc', 'none', 'noreply', 'notification', 'notifications', 'ns', 'ns0', 'ns1', 'ns2', 'ns3', 'ns4', 'ns5', 'ns6', 'ns7', 'ns8', 'ns9', 'null', 'oauth', 'oauth2', 'offer', 'offers', 'online', 'openid', 'order', 'orders', 'overview', 'owner', 'page', 'pages', 'partners', 'passwd', 'password', 'pay', 'payment', 'payments', 'photo', 'photos', 'pixel', 'plans', 'plugins', 'policies', 'policy', 'pop', 'pop3', 'popular', 'portfolio', 'post', 'postfix', 'postmaster', 'poweruser', 'preferences', 'premium', 'press', 'previous', 'pricing', 'print', 'private', 'prod', 'product', 'production', 'profiles', 'project', 'projects', 'public', 'purchase', 'put', 'quota', 'redirect', 'reduce', 'refund', 'refunds', 'register', 'registration', 'remove', 'replies', 'reply', 'report', 'request', 'request-password', 'reset-password', 'response', 'return', 'returns', 'review', 'reviews', 'robots.txt', 'root', 'rootuser', 'rsa-sha2-2', 'rsa-sha2-512', 'rss', 'rules', 'sales', 'save', 'script', 'sdk', 'search', 'secure', 'security', 'select', 'session', 'sessions', 'settings', 'setup', 'share', 'shift', 'site', 'sitemap', 'sites', 'smtp', 'sort', 'source', 'sql', 'ssh', 'ssh-rsa', 'ssl', 'ssladmin', 'ssladministrator', 'sslwebmaster', 'stage', 'staging', 'stat', 'static', 'statistics', 'stats', 'status', 'store', 'style', 'styles', 'stylesheet', 'stylesheets', 'subdomain', 'subscribe', 'sudo', 'super', 'superuser', 'survey', 'sync', 'sysadmin', 'system', 'tablet', 'tag', 'tags', 'team', 'telnet', 'terms-of-use', 'test', 'testimonials', 'theme', 'themes', 'today', 'tools', 'topic', 'topics', 'tour', 'training', 'translate', 'translations', 'trending', 'trial', 'true', 'umac-128', 'umac-128-etm', 'umac-64', 'umac-64-etm', 'undefined', 'unfollow', 'unlike', 'update', 'upgrade', 'usenet', 'users', 'uucp', 'var', 'verify', 'video', 'view', 'void', 'vote', 'webmail', 'webmaster', 'website', 'widget', 'widgets', 'wpad', 'write', 'www', 'www-data', 'www1', 'www2', 'www3', 'www4', 'you', 'yourname', 'yourusername', 'zlib'];
}

enum UserActionTypes { nope, like, supperLike }

extension UserActionTypeExt on UserActionTypes {
  int get index {
    switch (this) {
      case UserActionTypes.like:
        return Const.kLikeAction;
      case UserActionTypes.supperLike:
        return Const.kSuperLikeAction;
      default:
        return Const.kNopeAction;
    }
  }

  String get imageName {
    switch (this) {
      case UserActionTypes.like:
        return AppImages.btLike;
      case UserActionTypes.supperLike:
        return AppImages.btSuperLike;
      default:
        return AppImages.btNope;
    }
  }
}


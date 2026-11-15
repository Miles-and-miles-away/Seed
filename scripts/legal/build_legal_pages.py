"""Render the in-app legal documents as static HTML for Firebase Hosting.

Reads lib/features/settings/data/legal_content.dart (the single source
of truth shown inside the app) and writes public/privacy.html,
public/terms.html, public/delete-account.html and public/index.html,
plus the Android tester page public/beta.html.
Run from the repo root after editing legal_content.dart:

    python3 scripts/legal/build_legal_pages.py
"""

from __future__ import annotations

import html
import json
import re
from pathlib import Path

BETA_GROUP_URL = 'https://groups.google.com/g/seed-android-testers'
BETA_OPT_IN_URL = 'https://play.google.com/apps/testing/com.seedahabit.app'
BETA_STORE_URL = 'https://play.google.com/store/apps/details?id=com.seedahabit.app'
TESTFLIGHT_APP_URL = 'https://apps.apple.com/app/testflight/id899247664'
TESTFLIGHT_INVITE_URL = 'https://testflight.apple.com/join/tjcFtktN'

ROOT = Path(__file__).resolve().parents[2]
DART = ROOT / 'lib' / 'features' / 'settings' / 'data' / 'legal_content.dart'
ARB_DIR = ROOT / 'lib' / 'core' / 'l10n'
OUT = ROOT / 'public'

LANGS = ['en', 'ja', 'es']
LANG_NAMES = {'en': 'English', 'ja': '日本語', 'es': 'Español'}

STRING_RE = re.compile(r"""'((?:[^'\\]|\\.)*)'|"((?:[^"\\]|\\.)*)\"""")
SECTION_RE = re.compile(
    r'LegalSection\(\s*title:\s*(?P<title>(?:\s*(?:\'(?:[^\'\\]|\\.)*\''
    r'|"(?:[^"\\]|\\.)*"))+),\s*body:\s*(?P<body>(?:\s*(?:\'(?:[^\'\\]|\\.)*\''
    r'|"(?:[^"\\]|\\.)*"))+),?\s*\)',
    re.S,
)
LIST_RE = re.compile(r'const (_\w+) = \[(.*?)\n\];', re.S)


def dart_string(concatenated: str, consts: dict[str, str]) -> str:
    """Join adjacent Dart string literals and resolve escapes/consts."""
    out = []
    for single, double in STRING_RE.findall(concatenated):
        out.append(single if single else double)
    text = ''.join(out)
    text = text.replace('\\n', '\n').replace("\\'", "'").replace('\\"', '"')
    for name, value in consts.items():
        text = text.replace(f'${name}', value)
    return text


def parse_dart() -> tuple[dict[str, str], dict[str, list[tuple[str, str]]]]:
    src = DART.read_text(encoding='utf-8')
    consts = {
        m.group(1): m.group(2)
        for m in re.finditer(r"const (_\w+) = '([^']*)';", src)
    }
    lists: dict[str, list[tuple[str, str]]] = {}
    for name, body in LIST_RE.findall(src):
        sections = [
            (
                dart_string(m.group('title'), consts),
                dart_string(m.group('body'), consts),
            )
            for m in SECTION_RE.finditer(body)
        ]
        if sections:
            lists[name] = sections
    return consts, lists


def arb(lang: str) -> dict[str, str]:
    data = json.loads((ARB_DIR / f'app_{lang}.arb').read_text(encoding='utf-8'))
    return {k: v for k, v in data.items() if not k.startswith('@')}


def body_html(body: str) -> str:
    """Bullet lists become <ul>; other paragraphs become <p>."""
    parts: list[str] = []
    bullets: list[str] = []

    def flush() -> None:
        if bullets:
            parts.append(
                '<ul>' + ''.join(f'<li>{b}</li>' for b in bullets) + '</ul>'
            )
            bullets.clear()

    for para in body.split('\n\n'):
        lines = para.split('\n')
        for line in lines:
            if line.startswith('- '):
                bullets.append(html.escape(line[2:]))
            else:
                flush()
                if line.strip():
                    parts.append(f'<p>{html.escape(line)}</p>')
        flush()
    return ''.join(parts)


CSS = """
:root{color-scheme:light dark;--fg:#1f2a1f;--bg:#f7f4ec;--muted:#5b665b;
--accent:#3b7a4a;--card:#fffdf7;--line:#e3ded2}
@media(prefers-color-scheme:dark){:root{--fg:#ece9df;--bg:#171b17;
--muted:#a8b0a8;--accent:#7cc48d;--card:#1f241f;--line:#2f362f}}
*{box-sizing:border-box}body{margin:0;font:16px/1.6 system-ui,-apple-system,
"Segoe UI",Roboto,"Hiragino Sans","Noto Sans JP",sans-serif;color:var(--fg);
background:var(--bg)}main{max-width:44rem;margin:0 auto;padding:2rem 1.25rem 4rem}
header{display:flex;flex-wrap:wrap;gap:.75rem 1.5rem;align-items:baseline;
justify-content:space-between;border-bottom:1px solid var(--line);
padding-bottom:1rem;margin-bottom:1.5rem}header a{color:var(--accent);
text-decoration:none;font-weight:600}nav a{margin-right:1rem}
h1{font-size:1.6rem;margin:.5rem 0 .25rem}h2{font-size:1.15rem;margin:1.75rem 0 .5rem}
.meta{color:var(--muted);font-size:.9rem}.lang{display:flex;gap:.5rem;
flex-wrap:wrap;margin:1rem 0 2rem}.lang a{padding:.25rem .75rem;border:1px solid
var(--line);border-radius:999px;color:var(--fg);text-decoration:none;
font-size:.9rem}section[lang]{padding-top:1rem}section[lang]+section[lang]{
border-top:1px solid var(--line);margin-top:2.5rem}ul{padding-left:1.25rem}
ol{padding-left:1.25rem}code{background:var(--card);border:1px solid var(--line);
padding:.05rem .35rem;border-radius:4px}
"""


def page(
    title: str,
    sections_by_lang: dict[str, str],
    updated: str,
    description: str = '',
    extra_css: str = '',
    hero: str = '',
) -> str:
    langs = [lang for lang in LANGS if sections_by_lang.get(lang)]
    switcher = ''.join(
        f'<a href="#{lang}">{LANG_NAMES[lang]}</a>' for lang in langs
    ) if len(langs) > 1 else ''
    blocks = ''.join(
        f'<section lang="{lang}" id="{lang}">{sections_by_lang[lang]}</section>'
        for lang in langs
    )
    meta = (
        f'<p class="meta">Last updated {html.escape(updated)}</p>'
        if updated
        else ''
    )
    desc = (
        f'<meta name="description" content="{html.escape(description)}">\n'
        if description
        else ''
    )
    return f"""<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
{desc}<title>{html.escape(title)} - Seed</title>
<style>{CSS}{extra_css}</style>
</head>
<body>
<main>
<header>
<a href="/">Seed</a>
<nav><a href="/privacy">Privacy Policy</a><a href="/terms">Terms of Service</a>
<a href="/delete-account">Delete Account</a></nav>
</header>
<h1>{html.escape(title)}</h1>
{meta}{hero}
<div class="lang">{switcher}</div>
{blocks}
</main>
</body>
</html>
"""


def legal_page(
    title: str, lists: dict[str, list[tuple[str, str]]], prefix: str, updated: str
) -> str:
    by_lang = {}
    for lang in LANGS:
        sections = lists[f'_{prefix}{lang.capitalize()}']
        by_lang[lang] = ''.join(
            f'<h2>{html.escape(t)}</h2>{body_html(b)}' for t, b in sections
        )
    return page(title, by_lang, updated)


DELETE_TEXT = {
    'en': {
        'intro': 'You can delete your Seed account and all associated data '
        'at any time from inside the app.',
        'steps': 'In the app, open {path}. Confirm the dialog and your '
        'account is deleted.',
        'what': 'Deleting your account permanently removes your profile, '
        'action history, daily summaries, mascot progress and settings '
        'from our servers. This cannot be undone.',
        'alt': 'If you can no longer sign in, email {email} from the address '
        'registered on the account. Before deleting anything, we will reply '
        'to that address and ask you to confirm.',
    },
    'ja': {
        'intro': 'Seedのアカウントと関連するすべてのデータは、いつでもアプリ内'
        'から削除できます。',
        'steps': 'アプリで {path} を開き、確認ダイアログで承認するとアカウント'
        'が削除されます。',
        'what': 'アカウントを削除すると、プロフィール、アクション履歴、日次'
        'サマリー、マスコットの進行状況、設定がサーバーから完全に削除されます。'
        'この操作は取り消せません。',
        'alt': 'サインインできない場合は、アカウントに登録したメールアドレス'
        'から {email} にご連絡ください。削除の前に、そのアドレス宛てに確認'
        'のメールをお送りします。',
    },
    'es': {
        'intro': 'Puede eliminar su cuenta de Seed y todos los datos '
        'asociados en cualquier momento desde la aplicación.',
        'steps': 'En la aplicación, abra {path}. Confirme el diálogo y su '
        'cuenta quedará eliminada.',
        'what': 'Eliminar su cuenta borra permanentemente de nuestros '
        'servidores su perfil, historial de acciones, resúmenes diarios, '
        'progreso de la mascota y ajustes. Esta acción no se puede deshacer.',
        'alt': 'Si ya no puede iniciar sesión, escriba a {email} desde la '
        'dirección registrada en la cuenta. Antes de eliminar nada, le '
        'responderemos a esa dirección para que lo confirme.',
    },
}


def delete_page(email: str, updated: str) -> str:
    by_lang = {}
    for lang in LANGS:
        strings = arb(lang)
        path = ' > '.join(
            html.escape(strings[k])
            for k in (
                'navProfile',
                'settingsTitle',
                'settingsAccount',
                'accountSettingsDeleteAccount',
            )
        )
        t = DELETE_TEXT[lang]
        mail = f'<a href="mailto:{email}">{email}</a>'
        steps = html.escape(t['steps']).replace('{path}', f'<code>{path}</code>')
        alt = html.escape(t['alt']).replace('{email}', mail)
        by_lang[lang] = (
            f'<p>{html.escape(t["intro"])}</p>'
            f'<p>{steps}</p>'
            f'<p>{html.escape(t["what"])}</p>'
            f'<p>{alt}</p>'
        )
    return page('Delete Your Account', by_lang, updated)


def index_page(email: str) -> str:
    mail = html.escape(email)
    body = (
        '<p>Seed is a sustainability habit tracker for iOS and Android.</p>'
        f'<p>Support: <a href="mailto:{mail}">{mail}</a></p>'
        '<ul><li><a href="/privacy">Privacy Policy</a></li>'
        '<li><a href="/terms">Terms of Service</a></li>'
        '<li><a href="/delete-account">Delete your account</a></li></ul>'
    )
    return page('Seed', {'en': body}, '')


BETA_CSS = """
.lead{font-size:1.1rem}.agree{background:var(--card);border:1px solid
var(--line);border-radius:12px;padding:.25rem 1.25rem;margin:1.5rem 0}
h3{font-size:1.05rem;margin:1.25rem 0 .25rem}.steps{list-style:none;padding:0;
counter-reset:step}.steps>li{counter-increment:step;position:relative;
padding-left:2.75rem;margin:1.75rem 0}.steps>li::before{content:counter(step);
position:absolute;left:0;top:0;width:2rem;height:2rem;border-radius:50%;
background:var(--accent);color:var(--bg);font-weight:700;display:flex;
align-items:center;justify-content:center}.steps h3{margin-top:.2rem}
.btn{display:block;margin-top:.75rem;padding:.85rem 1rem;border-radius:12px;
background:var(--accent);color:var(--bg);font-weight:600;text-align:center;
text-decoration:none}.btn:focus-visible{outline:3px solid var(--fg);
outline-offset:2px}section a{color:var(--accent);overflow-wrap:anywhere}
.hero{display:block;width:100%;height:auto;border-radius:12px;margin:.75rem 0 0}
"""

BETA_HERO = (
    '<img class="hero" src="/images/seed-preview.webp" width="1400" height="744" '
    'alt="Four Seed screens: the home screen with the mascot, logging an '
    'action, the Climate Action goal, and the fact pairs game">'
)

BETA_TEXT = {
    'en': {
        'lead': 'Seed is a free daily habit tracker for sustainability. Log the '
        'everyday things you already do, or want to do more of: taking the '
        'train instead of driving, a meat-free dinner, drying washing on the '
        'line. Each one earns points based on roughly how much CO2 it saves, '
        'and your mascot grows as you go.',
        'about': 'The estimates come from published research and official data, '
        'with sources cited in the app, and actions are linked to the UN '
        'Sustainable Development Goals. There are daily and longer challenges, '
        'an Eco-Dex of facts you unlock as you log, a couple of quiz games, and '
        'calculators for comparing journeys, meals and home appliances. Seed is '
        'in English, Japanese and Spanish.',
        'why': 'Seed is made by one developer, and right now it needs help '
        'finding bugs and improving usability: what is confusing or broken, '
        'whether a number or translation looks wrong, and whether it actually '
        'makes you want to keep logging.',
        'agree_title': "What you're agreeing to",
        'agree': [
            'About 2 minutes to join.',
            'On Android, leaving Seed installed for a fortnight (14 days). You '
            'do not need to use it every day.',
            'Creating an account. You can delete it, and your data, from inside '
            'the app at any time.',
            'Free, with no ads and no payment.',
            'No emails from the group, and no spam.',
            'Updates arrive automatically through Google Play or TestFlight.',
            'Leaving whenever you like once the 14 days are up.',
        ],
        'android_title': 'On Android',
        'android_intro': 'Android testers matter most right now. Google will '
        'not let a new app be published until at least 12 testers have stayed '
        'opted in for 14 days in a row.',
        'steps': [
            (
                'Join the Google Group',
                'Use the Google account that the Play Store on your phone uses. '
                'Tap the button, then join the group.',
                'Join the Google Group',
            ),
            (
                'Become a tester',
                'Open the invite while signed in to the same Google account, '
                'then tap Become a tester.',
                'Open the test invite',
            ),
            (
                'Install Seed from Google Play',
                'Install Seed like any other app. It can take a few minutes to '
                'appear after joining, so if it is not there yet, wait a little '
                'and try again.',
                'Install Seed from Google Play',
            ),
        ],
        'ios_title': 'On iPhone',
        'ios_steps': [
            (
                'Install TestFlight',
                "TestFlight is Apple's free app for trying apps before they "
                'reach the App Store.',
                'Get TestFlight on the App Store',
            ),
            (
                'Open the invite link',
                'Open the link on your iPhone, then tap Accept, then Install.',
                'Open the Seed invite',
            ),
        ],
        'faq_title': 'Questions',
        'faq': [
            (
                'Why Google Groups?',
                'Google Play lets developers invite testers through a Google '
                'Group. Joining the group is all it takes, so you never need to '
                'send anyone your email address.',
            ),
            (
                'Who can see that I joined?',
                'Other members cannot. Only the developer, as the group owner, '
                "can see members' email addresses. They are used only to run "
                'this test and are never shared.',
            ),
            (
                'Is it safe? Is it finished?',
                'Seed is in early testing, so expect a few rough edges: that is '
                'what your feedback is for. It is covered by the Seed {privacy}, '
                'and you can {delete} at any time.',
            ),
            (
                'Does testing on iPhone help too?',
                'Yes. Apple has no 12-tester rule, so iPhone testers do not '
                'unlock the Android launch, but your feedback is just as useful.',
            ),
            (
                'I installed Seed through Aurora or an APK. Does that count?',
                'No. Google only counts Google accounts that joined the test '
                'through Google Play, so please follow the steps above as well. '
                'If you already have the APK installed, uninstall it before '
                'installing Seed from Google Play.',
            ),
        ],
        'privacy': 'Privacy Policy',
        'delete': 'delete your account and data',
        'contact': 'Found a bug, a confusing screen, or a number that looks '
        'wrong? Use the feedback form in the app under Profile > Settings > '
        'Send Feedback, or email {email}. Thank you so much for your help.',
    },
    'ja': {
        'lead': 'Seedは、サステナブルな暮らしのための無料の習慣トラッカーです。'
        '車の代わりに電車を使う、肉を使わない夕食にする、洗濯物を外に干すなど、'
        'すでにしていることや、もっと増やしたいことを記録しましょう。アクション'
        'ごとに減らせるCO2のおおよその量に応じてポイントがもらえ、マスコットも'
        '成長していきます。',
        'about': '推定値は公表された研究や公的なデータに基づいており、出典は'
        'アプリ内に記載しています。アクションは国連の持続可能な開発目標（SDGs）'
        'と結びついています。毎日のチャレンジや複数日チャレンジ、記録するたびに'
        '地球の豆知識が解放されるエコ図鑑、ちょっとしたクイズゲーム、移動・'
        '食事・家電を比べられる計算ツールもあります。Seedは英語、日本語、スペイン語に対応して'
        'います。',
        'why': 'Seedはひとりの開発者が作っていて、今はバグ探しと使いやすさの'
        '改善に協力してくださる方を募集しています。分かりにくいところや動かない'
        'ところ、数字や翻訳のおかしな点、そして記録を続けたくなるかどうかを、'
        'ぜひ教えてください。',
        'agree_title': '参加にあたってお願いすること',
        'agree': [
            '参加にかかる時間は約2分です。',
            'Androidの場合は、14日間Seedをインストールしたままにしてください。'
            '毎日使う必要はありません。',
            'アカウントの作成が必要です。アカウントとデータは、アプリ内から'
            'いつでも削除できます。',
            '無料で、広告や支払いは一切ありません。',
            'グループからメールが届くことはなく、迷惑メールもありません。',
            'アップデートはGoogle PlayまたはTestFlightから自動で届きます。',
            '14日が過ぎたら、いつでもテストをやめられます。',
        ],
        'android_title': 'Androidの場合',
        'android_intro': '今いちばん必要なのはAndroidのテスターです。Googleの'
        'ルールでは、新しいアプリを公開するには、12人以上のテスターが14日間'
        '続けてテストに参加している必要があります。',
        'steps': [
            (
                'Google グループに参加する',
                'スマートフォンのPlay ストアで使っているGoogle アカウントを'
                '使ってください。ボタンをタップして、グループに参加します。',
                'Google グループに参加',
            ),
            (
                'テスターになる',
                '同じGoogle アカウントでログインしたまま招待ページを開き、'
                'テスターになるためのボタンをタップしてください。',
                'テストへの招待を開く',
            ),
            (
                'Google PlayからSeedをインストールする',
                'ほかのアプリと同じようにSeedをインストールできます。参加してから'
                '表示されるまで数分かかることがあるので、見つからない場合は少し'
                '待ってからもう一度お試しください。',
                'Google PlayからSeedをインストール',
            ),
        ],
        'ios_title': 'iPhoneの場合',
        'ios_steps': [
            (
                'TestFlightをインストールする',
                'TestFlightは、App Storeで公開される前のアプリを試すための'
                'Appleの無料アプリです。',
                'App StoreでTestFlightを入手',
            ),
            (
                '招待リンクを開く',
                'iPhoneでリンクを開き、TestFlightで招待を受け入れてから'
                'インストールしてください。',
                'Seedの招待を開く',
            ),
        ],
        'faq_title': 'よくある質問',
        'faq': [
            (
                'なぜGoogle グループを使うのですか？',
                'Google Playでは、Google グループを通じてテスターを招待できます。'
                'グループに参加するだけでよいので、誰かにメールアドレスを送る'
                '必要はありません。',
            ),
            (
                '参加したことは、誰から見えますか？',
                'ほかのメンバーには見えません。グループのオーナーである開発者だけが'
                'メンバーのメールアドレスを確認できます。このアドレスはテストの'
                '運営にのみ使用し、ほかの人と共有することはありません。',
            ),
            (
                '安全ですか？完成していますか？',
                'Seedはまだテストの初期段階なので、不具合や使いにくいところも'
                'あると思います。それを見つけるために、皆さんのご意見が役に'
                '立ちます。このテストにはSeedの{privacy}が適用され、{delete}は'
                'いつでも削除できます。',
            ),
            (
                'iPhoneでのテストも役に立ちますか？',
                'はい。Appleには「テスター12人」のような条件がないため、iPhone'
                'でのテストはAndroidの公開条件の人数には含まれませんが、いただく'
                'ご意見は同じくらい役に立ちます。',
            ),
            (
                'AuroraやAPKでSeedをインストールしました。数に入りますか？',
                'いいえ。数に入るのは、Google Playからテストに参加したGoogle '
                'アカウントだけです。お手数ですが、上の手順でも参加してください。'
                'APKをインストール済みの場合は、先にアンインストールしてから'
                'Google PlayでSeedをインストールしてください。',
            ),
        ],
        'privacy': 'プライバシーポリシー',
        'delete': 'アカウントとデータ',
        'contact': 'バグや分かりにくい画面、おかしな数字を見つけたら、アプリの'
        '「プロフ」>「設定」>「フィードバックを送る」のフォームから、または'
        '{email}宛てのメールでお知らせください。ご協力、本当にありがとう'
        'ございます。',
    },
    'es': {
        'lead': 'Seed es una aplicación gratuita para crear hábitos sostenibles '
        'en el día a día. Registra lo que ya haces, o lo que quieres hacer más: '
        'ir en tren en vez de en coche, una cena sin carne, tender la ropa. '
        'Cada acción suma puntos según una estimación del CO2 que ahorra, y '
        'tu mascota crece contigo.',
        'about': 'Las estimaciones se basan en investigaciones publicadas y '
        'datos oficiales, con las fuentes citadas en la aplicación, y las '
        'acciones están vinculadas a los Objetivos de Desarrollo Sostenible de '
        'la ONU. Hay desafíos diarios y más largos, un Eco-Dex de datos que '
        'desbloqueas a medida que registras acciones, un par de juegos de '
        'preguntas y calculadoras para comparar trayectos, comidas y '
        'electrodomésticos. Seed está disponible en inglés, japonés y español.',
        'why': 'Seed la desarrolla una sola persona y ahora mismo necesita '
        'ayuda para encontrar errores y mejorar la usabilidad: qué resulta '
        'confuso o no funciona, si algún número o traducción parece incorrecto '
        'y si de verdad te anima a seguir registrando acciones.',
        'agree_title': 'A qué te comprometes',
        'agree': [
            'Unirte lleva unos 2 minutos.',
            'En Android, mantener Seed instalada durante 14 días. No hace falta '
            'usarla a diario.',
            'Crear una cuenta. Puedes eliminarla, junto con tus datos, desde la '
            'propia aplicación cuando quieras.',
            'Es gratis, sin anuncios y sin pagos.',
            'No recibirás correos del grupo, ni spam.',
            'Las actualizaciones llegan solas a través de Google Play o '
            'TestFlight.',
            'Pasados los 14 días, puedes salir cuando quieras.',
        ],
        'android_title': 'En Android',
        'android_intro': 'Ahora mismo hacen más falta testers en Android. '
        'Google no permite publicar una aplicación nueva hasta que al menos 12 '
        'testers hayan permanecido en la prueba durante 14 días seguidos.',
        'steps': [
            (
                'Únete al grupo de Google',
                'Usa la cuenta de Google que usas en la Play Store de tu móvil. '
                'Toca el botón y únete al grupo.',
                'Unirse al grupo de Google',
            ),
            (
                'Hazte tester',
                'Abre la invitación con la misma cuenta de Google y toca el '
                'botón para hacerte tester.',
                'Abrir la invitación',
            ),
            (
                'Instala Seed desde Google Play',
                'Instala Seed como cualquier otra aplicación. Puede tardar unos '
                'minutos en aparecer después de unirte; si aún no aparece, espera '
                'un poco y vuelve a intentarlo.',
                'Instalar Seed desde Google Play',
            ),
        ],
        'ios_title': 'En iPhone',
        'ios_steps': [
            (
                'Instala TestFlight',
                'TestFlight es la aplicación gratuita de Apple para probar '
                'apps antes de que lleguen a la App Store.',
                'Descargar TestFlight en la App Store',
            ),
            (
                'Abre el enlace de invitación',
                'Abre el enlace en tu iPhone, acepta la invitación en TestFlight '
                'y después instala Seed.',
                'Abrir la invitación de Seed',
            ),
        ],
        'faq_title': 'Preguntas frecuentes',
        'faq': [
            (
                '¿Por qué Grupos de Google?',
                'Google Play permite invitar a testers a través de un grupo de '
                'Google. Basta con unirte al grupo, así que no tienes que enviar '
                'tu dirección de correo a nadie.',
            ),
            (
                '¿Quién puede ver que me he unido?',
                'Los demás miembros, no. Solo el desarrollador, como propietario '
                'del grupo, puede ver las direcciones de correo de los miembros. '
                'Se usan únicamente para gestionar esta prueba y nunca se '
                'comparten.',
            ),
            (
                '¿Es segura? ¿Está terminada?',
                'Seed está en una fase temprana de pruebas, así que cuenta con '
                'que tenga algún fallo: para eso sirven tus comentarios. Se '
                'aplica la {privacy} de Seed y puedes {delete} en cualquier '
                'momento.',
            ),
            (
                '¿Sirve también probarla en iPhone?',
                'Sí. Apple no exige 12 testers, así que los testers de iPhone no '
                'cuentan para el lanzamiento en Android, pero tus comentarios son '
                'igual de útiles.',
            ),
            (
                'He instalado Seed con Aurora o con un APK. ¿Cuenta?',
                'No. Google solo contabiliza las cuentas de Google que se hayan '
                'unido a '
                'la prueba a través de Google Play, así que sigue también los '
                'pasos de arriba. Si ya tienes instalado el APK, desinstálalo '
                'antes de instalar Seed desde Google Play.',
            ),
        ],
        'privacy': 'Política de privacidad',
        'delete': 'eliminar tu cuenta y tus datos',
        'contact': '¿Has encontrado un error, una pantalla confusa o un número '
        'que no cuadra? Usa el formulario de la aplicación en «Perfil > Ajustes '
        '> Enviar comentarios» o escribe a {email}. ¡Muchas gracias por tu '
        'ayuda!',
    },
}


def linked(text: str, links: dict[str, str]) -> str:
    out = html.escape(text)
    for key, anchor in links.items():
        out = out.replace(f'{{{key}}}', anchor)
    return out


def beta_steps(steps: list[tuple[str, str, str]], urls: tuple[str, ...]) -> str:
    items = ''.join(
        f'<li><h3>{html.escape(title)}</h3><p>{html.escape(body)}</p>'
        f'<a class="btn" href="{html.escape(url)}">{html.escape(label)}</a>'
        '</li>'
        for (title, body, label), url in zip(steps, urls)
    )
    return f'<ol class="steps" role="list">{items}</ol>'


def beta_page(email: str) -> str:
    android_urls = (BETA_GROUP_URL, BETA_OPT_IN_URL, BETA_STORE_URL)
    ios_urls = (TESTFLIGHT_APP_URL, TESTFLIGHT_INVITE_URL)
    by_lang = {}
    for lang in LANGS:
        t = BETA_TEXT[lang]
        links = {
            'email': f'<a href="mailto:{email}">{email}</a>',
            'privacy': f'<a href="/privacy">{html.escape(t["privacy"])}</a>',
            'delete': f'<a href="/delete-account">{html.escape(t["delete"])}</a>',
        }
        agree = ''.join(f'<li>{html.escape(a)}</li>' for a in t['agree'])
        faq = ''.join(
            f'<h3>{html.escape(q)}</h3><p>{linked(a, links)}</p>'
            for q, a in t['faq']
        )
        by_lang[lang] = (
            f'<p class="lead">{html.escape(t["lead"])}</p>'
            f'<p>{html.escape(t["about"])}</p>'
            f'<p>{html.escape(t["why"])}</p>'
            f'<div class="agree"><h2>{html.escape(t["agree_title"])}</h2>'
            f'<ul>{agree}</ul></div>'
            f'<h2>{html.escape(t["android_title"])}</h2>'
            f'<p>{html.escape(t["android_intro"])}</p>'
            f'{beta_steps(t["steps"], android_urls)}'
            f'<h2>{html.escape(t["ios_title"])}</h2>'
            f'{beta_steps(t["ios_steps"], ios_urls)}'
            f'<h2>{html.escape(t["faq_title"])}</h2>{faq}'
            f'<p>{linked(t["contact"], links)}</p>'
        )
    return page(
        'Help test Seed',
        by_lang,
        '',
        description='Help Seed launch. Join the test on Android or iPhone in '
        'about 2 minutes: free, no ads, no payment.',
        extra_css=BETA_CSS,
        hero=BETA_HERO,
    )


def main() -> None:
    consts, lists = parse_dart()
    updated = consts['_lastUpdated']
    email = consts['_contactEmail']
    OUT.mkdir(exist_ok=True)
    (OUT / 'privacy.html').write_text(
        legal_page('Privacy Policy', lists, 'privacy', updated), encoding='utf-8'
    )
    (OUT / 'terms.html').write_text(
        legal_page('Terms of Service', lists, 'terms', updated), encoding='utf-8'
    )
    (OUT / 'delete-account.html').write_text(
        delete_page(email, updated), encoding='utf-8'
    )
    (OUT / 'index.html').write_text(index_page(email), encoding='utf-8')
    (OUT / 'beta.html').write_text(beta_page(email), encoding='utf-8')
    for name, sections in lists.items():
        print(f'{name}: {len(sections)} sections')


if __name__ == '__main__':
    main()

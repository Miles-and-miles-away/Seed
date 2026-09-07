"""Render the in-app legal documents as static HTML for Firebase Hosting.

Reads lib/features/settings/data/legal_content.dart (the single source
of truth shown inside the app) and writes public/privacy.html,
public/terms.html, public/delete-account.html and public/index.html.
Run from the repo root after editing legal_content.dart:

    python3 scripts/legal/build_legal_pages.py
"""

from __future__ import annotations

import html
import json
import re
from pathlib import Path

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


def page(title: str, sections_by_lang: dict[str, str], updated: str) -> str:
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
    return f"""<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>{html.escape(title)} - Seed</title>
<style>{CSS}</style>
</head>
<body>
<main>
<header>
<a href="/">Seed</a>
<nav><a href="/privacy">Privacy Policy</a><a href="/terms">Terms of Service</a>
<a href="/delete-account">Delete Account</a></nav>
</header>
<h1>{html.escape(title)}</h1>
{meta}
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
        'registered on the account and we will delete it for you.',
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
        'から {email} にご連絡ください。こちらで削除します。',
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
        'dirección registrada en la cuenta y la eliminaremos por usted.',
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


def index_page() -> str:
    body = (
        '<p>Seed is a sustainability habit tracker for iOS and Android.</p>'
        '<ul><li><a href="/privacy">Privacy Policy</a></li>'
        '<li><a href="/terms">Terms of Service</a></li>'
        '<li><a href="/delete-account">Delete your account</a></li></ul>'
    )
    return page('Seed', {'en': body}, '')


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
    (OUT / 'index.html').write_text(index_page(), encoding='utf-8')
    for name, sections in lists.items():
        print(f'{name}: {len(sections)} sections')


if __name__ == '__main__':
    main()

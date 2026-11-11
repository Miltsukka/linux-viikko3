#!/usr/bin/env bash

GENERATED_AT=$(date '+%Y-%m-%d %H:%M:%S %Z')
UPTIME_TEXT=$(uptime -p)
DISK_USAGE=$(df -P / | awk 'NR==2 {print $5}')
DISK_PERCENT=${DISK_USAGE%\%}
MEM_TOTAL=$(free -m | awk '/^Mem:/ {print $2}')
MEM_AVAILABLE=$(free -m | awk '/^Mem:/ {print $7}')

disk_status() {
    if [ "$1" -ge 80 ]; then
        echo "WARNING"
    else
        echo "OK"
    fi
}

DISK_STATUS=$(disk_status "$DISK_PERCENT")
cat > /var/www/html/viikko3/index.html <<EOF
<!DOCTYPE html>
<html lang="fi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Viikko 3 – Palvelimen tilaraportti</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f1f5f9;
            color: #172033;
            max-width: 800px;
            margin: 40px auto;
            padding: 20px;
        }
        h1 { color: #173b65; }
        section {
            background: white;
            padding: 24px;
            border-radius: 12px;
            margin-bottom: 20px;
        }
        td, th {
            padding: 12px;
            border-bottom: 1px solid #ddd;
            text-align: left;
        }
        table { width: 100%; }
    </style>
</head>
<body>
    <h1>Palvelimen tilaraportti</h1>
    <p>Linux – Viikkotehtävä 3</p>

    <section>
        <h2>Palvelimen tiedot</h2>
        <table>
            <tr><th>Raportti luotu</th><td>$GENERATED_AT</td></tr>
            <tr><th>Palvelimen käynnissäoloaika</th><td>$UPTIME_TEXT</td></tr>
            <tr><th>Levyn käyttöaste</th><td>$DISK_USAGE</td></tr>
            <tr><th>Levytilan tila</th><td>$DISK_STATUS</td></tr>
            <tr><th>RAM yhteensä</th><td>$MEM_TOTAL MiB</td></tr>
            <tr><th>RAM käytettävissä</th><td>$MEM_AVAILABLE MiB</td></tr>
        </table>
    </section>

    <section>
        <h2>Levytilan varoitusrajat</h2>
        <p>Alle 80 % = OK</p>
        <p>80 % tai enemmän = WARNING</p>
    </section>
<section>
    <h2>Komennot ja niiden toiminta</h2>
    <p>date: näyttää päivämäärän, kellonajan ja aikavyöhykkeen.</p>
    <p>uptime -p: näyttää palvelimen käynnissäoloajan.</p>
    <p>df -P / | awk 'NR==2 {print $5}': näyttää juurilevyn käyttöprosentin.</p>
    <p>free -m: näyttää RAM-muistin tiedot.</p>
</section>

<section>
    <h2>Skriptin toiminta</h2>
    <p>Bash-skripti kerää palvelimen tiedot Linux-komennoilla.
    Levyn käyttöasteen ollessa alle 80 prosenttia tila on OK.
    Muuten tila on WARNING.</p>
    <p>Cron suorittaa skriptin automaattisesti minuutin välein.</p>
</section>

<section>
    <h2>Testitulokset</h2>
    <p>Bash-skriptin syntaksitarkistus onnistui.</p>
    <p>Levytilan testit: 50 % = OK, 80 % = WARNING,
    90 % = WARNING.</p>
    <p>Automaattinen päivitys havaittiin klo 14.31 ja 14.33.</p>
    <p>Palvelin käynnistettiin uudelleen ja cron-palvelun
    toiminta tarkistettiin.</p>
</section>

<section>
    <h2>Opittu asia</h2>
    <p>Opin käyttämään Bash-skriptejä ja cron-ajastusta
    palvelimen tietojen automaattiseen päivittämiseen.</p>
</section>
<section>
    <h2>Linux-viikkotehtävät</h2>
    <p><a href="/">Viikko 1 – Verkkopalvelin</a></p>
    <p><a href="/viikko2/">Viikko 2 – Flask-kävijälaskuri</a></p>
    <p><a href="/viikko3/">Viikko 3 – Palvelimen tilaraportti</a></p>
</section>

<section>
    <h2>GitHub – Lähdekoodi</h2>
    <p><a href="https://github.com/Miltsukka/linux-viikko3">Viikon 3 lähdekoodi ja cron-ajastus GitHubissa</a></p>
</section>
</body>
</html>
EOF

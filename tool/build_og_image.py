#!/usr/bin/env python3
#
# Disegna `images/og-cover.png`, l'anteprima che LinkedIn, WhatsApp e Telegram
# mostrano quando qualcuno incolla il collegamento del portfolio o di un
# articolo.
#
#   python3 tool/build_og_image.py     dalla radice del repository
#
# Serve `pillow`. L'immagine sta in repo gia' disegnata: si rilancia solo quando
# cambiano il titolo della home o i colori.
#
# 1200x630 e' il rettangolo che LinkedIn ritaglia. Prima l'anteprima era
# `images/user_profile.png`, che e' lo screenshot di un progetto e non dice di
# chi e' il sito.
#
# I colori vengono da `css/style.css`: cambiato un token di la', va cambiato
# anche qui. I caratteri sono in `tool/fonts/`, gli stessi che le pagine
# prendono da Google Fonts, a peso variabile.
from PIL import Image, ImageDraw, ImageFont

W, H = 1200, 630
SFONDO = "#0b1117"  # --bg
SUPERFICIE = "#0f1722"  # --surface
TESTO = "#e7eef7"  # --text
MEDIO = "#9fb0c3"  # --muted
ACCENTO = "#11b5a4"  # --accent
BORDO = (231, 238, 247, 31)  # --border
MARGINE = 80

FONT = "tool/fonts/"


def titoli(peso, corpo):
    carattere = ImageFont.truetype(f"{FONT}SpaceGrotesk.ttf", corpo)
    carattere.set_variation_by_axes([peso])
    return carattere


def corpo_testo(peso, corpo):
    carattere = ImageFont.truetype(f"{FONT}SourceSans3.ttf", corpo)
    carattere.set_variation_by_axes([peso])
    return carattere


def main():
    img = Image.new("RGB", (W, H), SFONDO)
    disegno = ImageDraw.Draw(img, "RGBA")

    # Il quadrato «FB.» di favicon.svg.
    lato = 88
    disegno.rounded_rectangle(
        [MARGINE, 64, MARGINE + lato, 64 + lato],
        radius=22,
        fill=SUPERFICIE,
        outline=BORDO,
        width=2,
    )
    disegno.text(
        (MARGINE + lato / 2, 64 + lato / 2), "FB.", font=titoli(700, 36), fill="#ffffff", anchor="mm"
    )
    disegno.text(
        (MARGINE + lato + 22, 64 + lato / 2),
        "federicobernacca.com",
        font=titoli(600, 32),
        fill=TESTO,
        anchor="lm",
    )

    disegno.text((MARGINE, 196), "Federico Bernacca", font=titoli(700, 92), fill=TESTO)
    disegno.text((MARGINE, 298), "Backend Engineer", font=titoli(700, 92), fill=ACCENTO)

    sotto = corpo_testo(500, 31)
    for i, riga in enumerate(
        [
            "Ingegnere software con focus su backend robusti",
            "e applicazioni mobile affidabili.",
        ]
    ):
        disegno.text((MARGINE, 440 + i * 40), riga, font=sotto, fill=MEDIO)

    disegno.line([(MARGINE, 540), (W - MARGINE, 540)], fill=BORDO, width=1)
    disegno.text(
        (MARGINE, 578),
        "BACKEND  ·  MOBILE  ·  CYBERSECURITY",
        font=titoli(600, 22),
        fill=ACCENTO,
        anchor="lm",
    )

    img.save("images/og-cover.png", optimize=True)
    print("scritto images/og-cover.png")


if __name__ == "__main__":
    main()

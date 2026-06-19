#!/usr/bin/env bash
# Toggle Gamemode in MangoWM: disables/enables animations, blur, shadows, and gaps.

CURRENT=$(mmsg get animations 2>/dev/null || echo "1")

if [[ "$CURRENT" == "1" ]]; then
  mmsg set animations 0
  mmsg set blur 0
  mmsg set shadows 0
  mmsg set gappih 0
  mmsg set gappiv 0
  mmsg set gappoh 0
  mmsg set gappov 0
  notify-send 'Modo Jogo Ativado' 'Animações, blur, sombras e espaçamentos desativados.' -t 2000
else
  mmsg set animations 1
  mmsg set blur 1
  mmsg set shadows 1
  mmsg set gappih 5
  mmsg set gappiv 5
  mmsg set gappoh 10
  mmsg set gappov 10
  notify-send 'Modo Jogo Desativado' 'Configurações restauradas.' -t 2000
fi

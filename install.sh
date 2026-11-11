#!/bin/sh
# spacii installer: curl -fsSL https://raw.githubusercontent.com/Olegg000/spacii/main/install.sh | sh
set -e
URL="https://raw.githubusercontent.com/Olegg000/spacii/main/spacii"
DIR="${SPACII_DIR:-$HOME/.local/bin}"

if [ "$1" = "--uninstall" ]; then
  rm -f "$DIR/spacii" && echo "spacii удалён из $DIR"
  exit 0
fi

if ! command -v python3 >/dev/null 2>&1; then
  echo "Нужен python3. На macOS: xcode-select --install  (или brew install python)" >&2
  exit 1
fi

mkdir -p "$DIR"
if [ -f "./spacii" ] && head -1 ./spacii | grep -q python3; then
  cp ./spacii "$DIR/spacii"            # запуск из клона репозитория
else
  curl -fsSL "$URL" -o "$DIR/spacii"
fi
chmod +x "$DIR/spacii"
echo "Установлено: $DIR/spacii"

case ":$PATH:" in
  *":$DIR:"*) echo "Запуск: spacii" ;;
  *)
    case "${SHELL##*/}" in
      zsh) RC="$HOME/.zshrc" ;;
      bash) RC="$HOME/.bash_profile" ;;
      *) RC="" ;;
    esac
    if [ -n "$RC" ]; then
      printf '\n# spacii\nexport PATH="%s:$PATH"\n' "$DIR" >> "$RC"
      echo "Добавил $DIR в PATH ($RC). Откройте новый терминал и запустите: spacii"
    else
      echo "Добавьте $DIR в PATH и запустите: spacii"
    fi
    echo "Прямо сейчас: $DIR/spacii"
    ;;
esac

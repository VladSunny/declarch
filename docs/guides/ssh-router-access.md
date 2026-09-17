# Безопасный SSH-доступ к `declarch-pc` через роутер

Этот репозиторий управляет политикой SSHD и fail2ban только на Arch-хосте
`declarch-pc`. Адрес роутера, внешний порт и публичные ключи не хранятся в
репозитории. Роутер должен направлять внешний TCP-порт на `declarch-pc:22`.

## Добавить ключ

На клиенте создайте отдельный ключ с passphrase (или используйте уже
существующий):

```bash
ssh-keygen -t ed25519 -a 100 -f ~/.ssh/declarch-pc
```

Через локальную консоль `declarch-pc` добавьте содержимое
`~/.ssh/declarch-pc.pub` в `/home/vladg00dman/.ssh/authorized_keys`. Проверьте
права: каталог `.ssh` должен быть `0700`, файл `authorized_keys` — `0600`.
Перед включением запрета паролей оставьте открытой локальную консоль или уже
проверенное SSH-подключение.

## Установка

На `declarch-pc` сначала установите пакеты, затем примените chezmoi:

```bash
metapac sync
chezmoi apply
```

Скрипт chezmoi проверяет `sshd` и fail2ban перед перезагрузкой служб. Политика
разрешает только `vladg00dman` с ключом из `authorized_keys`; root, пароли,
keyboard-interactive, X11, agent forwarding и remote forwarding отключены.
Локальные туннели разрешены только к `127.0.0.1` и `::1`.

При первом запуске скрипт также создаёт отсутствующие server host keys в
`/etc/ssh/` через `ssh-keygen -A`. Они отличаются от пользовательских ключей в
`~/.ssh/authorized_keys`: первые нужны SSHD для запуска, вторые — для входа.

## Алиас и локальный туннель

Не коммитьте внешний адрес или порт. На клиенте добавьте в `~/.ssh/config`:

```sshconfig
Host declarch-pc-router
    HostName YOUR_ROUTER_ADDRESS
    Port YOUR_EXTERNAL_PORT
    User vladg00dman
    IdentityFile ~/.ssh/declarch-pc
    IdentitiesOnly yes
```

Откройте туннель к WebUI, который слушает только на самом `declarch-pc`:

```bash
ssh -N -L 3001:127.0.0.1:3001 declarch-pc-router
```

Затем откройте `http://127.0.0.1:3001` на клиенте. Для обычного входа:

```bash
ssh declarch-pc-router
```

## Диагностика и восстановление

На локальной консоли `declarch-pc` используйте:

```bash
sudo sshd -t
sudo sshd -T
sudo fail2ban-client -d
sudo systemctl status sshd.service fail2ban.service
sudo fail2ban-client status sshd
```

Не выполняйте намеренно неверные внешние входы с рабочего IP: после пяти ошибок
за десять минут fail2ban блокирует адрес на один час. Для ручной разблокировки:

```bash
sudo fail2ban-client set sshd unbanip YOUR_IP
```

Если новый drop-in заблокировал доступ, на локальной консоли временно удалите
его и перезагрузите SSHD:

```bash
sudo rm /etc/ssh/sshd_config.d/60-remote-access.conf
sudo sshd -t && sudo systemctl reload sshd.service
```

После исправления source-файла снова выполните `chezmoi apply`.

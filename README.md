# my-env

Ansible playbooks that turn a fresh **Ubuntu Desktop 26.04** install (default or extended selection) into a ready-to-work laptop.

## Quick start

On a clean machine, without cloning anything:

```bash
curl -fsSL https://raw.githubusercontent.com/lautsevich/my-env/master/install.sh | bash
```

Or from a clone:

```bash
git clone https://github.com/lautsevich/my-env.git ~/Projects/my-env
cd ~/Projects/my-env
./install.sh
```

`install.sh` upgrades the system and installs `git`, `ansible` and `make`, clones the repo to `~/Projects/my-env` if needed, then runs `make provision`. You'll be asked for your sudo password once.

Run it from your own graphical session, not over SSH: some tasks write GNOME settings to the current user's profile.

## Make targets

| Command | What it does |
|---|---|
| `make provision` | Installs Galaxy roles and runs the whole playbook |
| `make provision TAGS=social,graphics` | Runs only the selected groups |
| `make check` | Dry run (`--check --diff`): shows what would change, changes nothing. Accepts `TAGS` too |
| `make galaxy-install` | Installs the Galaxy roles from `requirements.yml` |

On a fresh machine `make check` can fail on tasks that depend on earlier ones (e.g. installing a package from a repository that isn't added yet in a dry run). It's meant for checking changes on an already provisioned machine.

## What gets installed

Galaxy roles. All of them carry the `roles` tag (`make provision TAGS=roles`), and each also has its own tag:

| Tag | Role | Contents |
|---|---|---|
| `php` | `geerlingguy.php`, `geerlingguy.composer` | PHP 8.5 + Composer. Apache is installed with `mod_php` but kept stopped and disabled |
| `nodejs` | `geerlingguy.nodejs` | Node.js 24.x from NodeSource |
| `docker` | `geerlingguy.docker` | Docker from Docker's repository; the current user is added to the `docker` group |
| `terraform` | `andrewrothstein.terraform` | Terraform |

Task groups:

| Tag | File | Contents |
|---|---|---|
| `common` | `playbooks/common.yml` | universe/multiverse check, `git-lfs`, `curl`, `build-essential` |
| `development` | `playbooks/development.yml` | GitKraken, VS Code, GitHub CLI, Claude Code, Claude Desktop, `python3-docker`, `sshpass` |
| `graphics` | `playbooks/graphics.yml` | Inkscape, Flameshot (bound to <kbd>PrtSc</kbd>) |
| `multimedia` | `playbooks/multimedia.yml` | VLC, Spotify, Ace Stream Player, SimpleScreenRecorder, OBS Studio, Ubuntu Restricted Extras |
| `social` | `playbooks/social.yml` | Slack, Telegram, Viber, Discord, Zoom |
| `utilities` | `playbooks/utilities.yml` | Bitwarden, Midnight Commander, Krusader, GNOME Tweaks, UFW enabled |
| `work` | `playbooks/work.yml` | Chromium, Opera, Google Chrome, LibreOffice |
| `entertainment` | `playbooks/entertainment.yml` | Steam |

## Adding an app

Each package gets its own task block in the matching `playbooks/<group>.yml`. Privilege escalation (`become`) is set once for the whole play, so tasks don't repeat it.

Don't add packages that ship with Ubuntu Desktop (Firefox, `snapd`, `openssh-client`, `ufw`, …) or that `install.sh` already installs (`git`, `ansible`, `make`). Only configure them.

Snap:

```yaml
- name: Install Example
  snap:
    name: example
```

Package from the Ubuntu archive:

```yaml
- name: Install Example
  apt:
    name: example
```

Package from a vendor's apt repository: add the repository with `deb822_repository`, then install:

```yaml
- name: Add Example repository
  deb822_repository:
    name: example
    uris: https://example.com/apt
    suites: stable
    components: main
    signed_by: https://example.com/key.asc
- name: Install Example
  apt:
    name: example
    update_cache: yes
```

Some vendor packages (Google Chrome, Claude Desktop) add their own apt source on install, with a different key path. That conflicts with the source Ansible added (`Conflicting values set for option Signed-By`). Turn their self-registration off in `/etc/default/<package>` before installing. See the Chrome tasks in `playbooks/work.yml` for an example.

## After provisioning

- Log out and back in so the `docker` group membership takes effect.
- The first <kbd>PrtSc</kbd> press makes GNOME ask for screenshot permission. Choose **Allow**, or Flameshot gets blocked.
- Zoom is installed from the official `.deb` and doesn't update itself. Update it from Zoom or by reinstalling the latest `.deb`. Everything else updates with `apt upgrade` or snap refresh.
- A repo cloned over HTTPS can't push over SSH. Once your SSH key is set up, switch the remote: `git remote set-url origin git@github.com:lautsevich/my-env.git`.

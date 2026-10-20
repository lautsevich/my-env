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
| `make provision TAGS=roles` | Runs only the Galaxy roles |
| `make provision TAGS=tasks` | Runs only the task groups, no roles |
| `make provision TAGS=social,graphics` | Runs only the selected groups (role and group tags can be mixed) |
| `make check` | Dry run (`--check --diff`): shows what would change, changes nothing. Accepts `TAGS` too |
| `make dry-run` | Dry run of everything: prints the commands `install.sh` would run, then runs `make check`. Accepts `TAGS` too. Same as `./install.sh --dry-run` |
| `make galaxy-install` | Installs the Galaxy roles from `requirements.yml` |

The apt cache update, disabling Apache and the final apt cleanup run on every invocation, whatever `TAGS` you pass.

A dry run still asks for the sudo password, because Ansible reads system state as root, and it installs the Galaxy roles into `~/.ansible`. It changes nothing else. On a fresh machine some tasks can't be checked for real: a package from a vendor repository can't be found until that repository is actually added. Those tasks show an error in the output, and the dry run carries on.

To dry-run without cloning: `curl -fsSL https://raw.githubusercontent.com/lautsevich/my-env/master/install.sh | bash -s -- --dry-run`. It prints the bootstrap commands only, since there's no repo to check yet.

## What gets installed

Galaxy roles. All of them carry the `roles` tag (`make provision TAGS=roles`), and each also has its own tag:

| Tag | Role | Contents |
|---|---|---|
| `php` | `geerlingguy.php`, `geerlingguy.composer` | PHP 8.5 + Composer. Apache is installed with `mod_php` but kept stopped and disabled |
| `nodejs` | `geerlingguy.nodejs` | Node.js 24.x from NodeSource |
| `docker` | `geerlingguy.docker` | Docker from Docker's repository; the current user is added to the `docker` group |
| `terraform` | `andrewrothstein.terraform` | Terraform |

Task groups. All of them carry the `tasks` tag, each has its own group tag, and every app has its own tag too (`make provision TAGS=zoom`):

| Group tag | File | App tags |
|---|---|---|
| `common` | `playbooks/common.yml` | `repositories` (universe/multiverse check), `git-lfs`, `curl`, `build-essential` |
| `system` | `playbooks/system.yml` | `keyboard` (us, ru, by, by+latin layouts; Alt+Shift to switch), `battery` (battery percentage in the top bar), `clock` (seconds in the top bar clock), `dark-theme` (dark color scheme, Yaru-dark GTK and icon themes), `ufw` (enables the firewall) |
| `development` | `playbooks/development.yml` | `gitkraken`, `vscode`, `gh`, `claude-code`, `claude-desktop`, `python-docker`, `sshpass` |
| `graphics` | `playbooks/graphics.yml` | `inkscape`, `flameshot` (bound to <kbd>PrtSc</kbd>) |
| `multimedia` | `playbooks/multimedia.yml` | `vlc`, `spotify`, `acestream`, `simplescreenrecorder`, `obs`, `restricted-extras` |
| `social` | `playbooks/social.yml` | `slack`, `telegram`, `viber`, `discord`, `zoom` |
| `utilities` | `playbooks/utilities.yml` | `bitwarden`, `mc`, `krusader`, `gnome-tweaks`, `pandoc` (Markdown converter) |
| `work` | `playbooks/work.yml` | `chromium`, `opera`, `chrome`, `libreoffice` |
| `entertainment` | `playbooks/entertainment.yml` | `steam` |

An app tag covers every task that app needs. For example, `chrome` runs the whole Google Chrome block: it adds the repository and then installs the package.

## Adding an app

Each app goes into the matching `playbooks/<group>.yml`, tagged with the app's name (`tags: [example]`). If the app needs a single task, write it as a plain task. If it needs several (repository, install, configuration), wrap them in a `block` named after the app and put the tag on the block. Privilege escalation (`become`) is set once for the whole play, so tasks don't repeat it.

Don't add packages that ship with Ubuntu Desktop (Firefox, `snapd`, `openssh-client`, `ufw`, …) or that `install.sh` already installs (`git`, `ansible`, `make`). Only configure them.

Snap:

```yaml
- name: Install Example
  snap:
    name: example
  tags: [example]
```

Package from the Ubuntu archive:

```yaml
- name: Install Example
  apt:
    name: example
  tags: [example]
```

Package from a vendor's apt repository: a block that adds the repository with `deb822_repository`, then installs:

```yaml
- name: Example
  tags: [example]
  block:
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

Some vendor packages (Google Chrome, Claude Desktop) add their own apt source on install, with a different key path. That conflicts with the source Ansible added (`Conflicting values set for option Signed-By`). Turn their self-registration off in `/etc/default/<package>` before installing. See the Google Chrome block in `playbooks/work.yml` for an example.

## After provisioning

- Log out and back in so the `docker` group membership takes effect.
- The first <kbd>PrtSc</kbd> press makes GNOME ask for screenshot permission. Choose **Allow**, or Flameshot gets blocked.
- Zoom is installed from the official `.deb` and doesn't update itself. Update it from Zoom or by reinstalling the latest `.deb`. Everything else updates with `apt upgrade` or snap refresh.
- A repo cloned over HTTPS can't push over SSH. Once your SSH key is set up, switch the remote: `git remote set-url origin git@github.com:lautsevich/my-env.git`.

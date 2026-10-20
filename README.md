# my-env

Ansible playbooks that turn a fresh **Ubuntu Desktop 26.04** install (default or extended selection) into a ready-to-work laptop.

## Quick start

On a clean machine, download the installer from a release tag, read it, then run it:

```bash
TAG=v2026.10.20   # the latest release tag, see Releases below
curl -fsSLo install.sh "https://raw.githubusercontent.com/lautsevich/my-env/$TAG/install.sh"
less install.sh
REF=$TAG bash install.sh
```

`install.sh` upgrades the system and installs `git`, `ansible` and `make`, then clones the repo at `REF` to `~/Projects/my-env`, enables the git hooks and runs `make provision`. You'll be asked for your sudo password once. Without `REF` it clones `master`. A clone made from a tag is on a detached HEAD; run `git switch master` before committing from it.

Using a tag, not `master`, means a new machine only gets a state you've checked: later pushes to `master`, including bad or malicious ones, don't reach it. The whole script runs from a `main` function called on its last line, so if the download is cut short, nothing runs.

From an existing clone, the installer uses that clone as it is:

```bash
git clone https://github.com/lautsevich/my-env.git ~/Projects/my-env
cd ~/Projects/my-env
./install.sh
```

Run it from your own graphical session, not over SSH: some tasks write GNOME settings to the current user's profile.

## Releases

After checking a set of changes (for example with `make check`), tag that commit and push the tag:

```bash
git tag v2026.10.20
git push origin v2026.10.20
```

Use that tag in the Quick start commands. Tags are named `vYYYY.MM.DD`; add a suffix (`v2026.10.20.1`) for a second release on the same day.

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

To dry-run without cloning, run the downloaded installer with `--dry-run`: `REF=$TAG bash install.sh --dry-run`. It prints the bootstrap commands only, since there's no repo to check yet.

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
| `system` | `playbooks/system.yml` | `monitors` (monitor layout), `keyboard` (layouts and switching shortcut), `volume-boost` (volume above 100%), `startup-sound` (startup sound), `no-sleep-on-ac` (automatic suspend on AC power), `battery` (battery percentage in the top bar), `clock` (seconds in the top bar clock), `dark-theme` (color scheme, GTK and icon themes), `night-light` (Night Light and its schedule), `tiling-popup` (Tiling Assistant popup workspaces), `timezone` (location services, automatic time zone), `projects-folder` (projects folder and its Files sidebar bookmark), `files-list-view` (default folder view in Files), `files-columns` (Files list view columns), `region` (regional formats for dates, numbers and currency), `dock` (pinned apps), `ufw` (firewall). All values come from `playbooks/vars/secrets.yml` |
| `development` | `playbooks/development.yml` | `gitkraken`, `vscode`, `gh`, `claude-code`, `claude-desktop`, `python-docker`, `sshpass` |
| `graphics` | `playbooks/graphics.yml` | `inkscape`, `flameshot` (bound to <kbd>PrtSc</kbd>) |
| `multimedia` | `playbooks/multimedia.yml` | `vlc`, `spotify`, `acestream`, `simplescreenrecorder`, `obs`, `restricted-extras` |
| `social` | `playbooks/social.yml` | `slack`, `telegram`, `viber`, `discord`, `zoom` |
| `utilities` | `playbooks/utilities.yml` | `bitwarden`, `mc`, `krusader`, `gnome-tweaks`, `pandoc` (Markdown converter) |
| `work` | `playbooks/work.yml` | `chromium`, `opera`, `chrome`, `default-browser` (sets Chrome as the default browser), `libreoffice` |
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
        signed_by: "{{ lookup('file', 'keys/example.asc') }}"
    - name: Install Example
      apt:
        name: example
        update_cache: yes
```

Repository signing keys are stored in `playbooks/files/keys/` instead of being downloaded on every run. That way a swapped key shows up in a diff. Before adding or updating a key, check its fingerprint against the one the vendor publishes:

```bash
gpg --show-keys playbooks/files/keys/example.asc
```

| Key file | Used by | Fingerprint |
|---|---|---|
| `github-cli.asc` | GitHub CLI | `2C61 0620 1985 B60E 6C7A C873 23F3 D4EA 7571 6059`, `7F38 BBB5 9D06 4DBC B3D8 4D72 5612 B364 6231 3325` |
| `anthropic.asc` | Claude Code, Claude Desktop | `31DD DE24 DDFA B679 F42D 7BD2 BAA9 29FF 1A7E CACE` |
| `google.asc` | Google Chrome | `EB4C 1BFD 4F04 2F6D DDCC EC91 7721 F63B D38B 4796` |

Some vendor packages (Google Chrome, Claude Desktop) add their own apt source on install, with a different key path. That conflicts with the source Ansible added (`Conflicting values set for option Signed-By`). Turn their self-registration off in `/etc/default/<package>` before installing. See the Google Chrome block in `playbooks/work.yml` for an example.

## Secrets

Secret values live in `playbooks/vars/secrets.yml`, encrypted with Ansible Vault: all the setting values used by `playbooks/system.yml` (layouts, theme, Night Light hours, dock apps, regional formats and so on), and later Wi-Fi passwords and the like. The `system` group is imported with `no_log: true` and `diff: false`, so its values never show up in the output. Whole files can be encrypted too: `playbooks/files/monitors.xml` is the vault-encrypted monitor layout, and the `copy` task decrypts it on the fly. To change it, run `ansible-vault edit --vault-password-file .vault-pass playbooks/files/monitors.xml`. Every `make provision` and `make check` run needs the vault password: it's read from `.vault-pass` in the project root if that file exists, otherwise you're asked for it. `.vault-pass` is git-ignored: create it by hand on each new machine before provisioning.

| Command | What it does |
|---|---|
| `make vault-edit` | Opens the decrypted secrets in your editor and re-encrypts them on save |
| `make vault-encrypt` | Encrypts every vault file that's in plain text (`secrets.yml`, `files/monitors.xml`); already encrypted files are skipped |
| `make git-hooks` | Enables the pre-commit hook that refuses to commit an unencrypted vault file. `install.sh` runs it for you |

Create it so that only you can read it:

```bash
install -m 600 /dev/null .vault-pass && nano .vault-pass
```

Keep the password somewhere safe outside the repo (e.g. Bitwarden). Without it, nothing in `secrets.yml` can be recovered. Never commit vault files unencrypted: run `make vault-encrypt` before committing. The first line of each file must be `$ANSIBLE_VAULT;1.1;AES256`. When you add a new encrypted file, add it to `VAULT_FILES` in the `Makefile`.

The pre-commit hook only works where it's enabled (`make git-hooks`), and `git commit --no-verify` skips it. As a second line of defense, turn on **Secret scanning** and **Push protection** in the GitHub repository settings (Settings → Code security). GitHub then rejects pushes that contain strings that look like secrets.

Every task that uses a secret value or copies an encrypted file must have `no_log: true` and `diff: false`. Otherwise Ansible prints the decrypted data in its output, and with `make check` (`--diff`) it prints the whole decrypted file. See the `Set monitor layout` task in `playbooks/system.yml`.

## After provisioning

- Log out and back in so the `docker` group membership takes effect.
- The first <kbd>PrtSc</kbd> press makes GNOME ask for screenshot permission. Choose **Allow**, or Flameshot gets blocked.
- Zoom is installed from the official `.deb`, pinned to a version and verified by SHA-256 (`zoom_version` and `zoom_sha256` in `playbooks/social.yml`). It doesn't update itself through apt: update it from Zoom. To move the playbook to a newer release, take the version from `curl -sIL https://zoom.us/client/latest/zoom_amd64.deb | grep -i location`, download that `.deb`, and put its version and `sha256sum` into the variables. Everything else updates with `apt upgrade` or snap refresh.
- A repo cloned over HTTPS can't push over SSH. Once your SSH key is set up, switch the remote: `git remote set-url origin git@github.com:lautsevich/my-env.git`.

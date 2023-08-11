# 2023年8月の新ジャッジにcargo-competeを対応させる方法
- cargo-competeは多分更新されると思います。その後は特にこの方法は必要ないと思います。
- cargo-equip等を使っていれば、おそらくcargo.tomlの[submit.transpile]のlanguage_idを「language_id = "5054"」に変更するだけでよいはずです。

cargo.tomlの[submit.transpile]を弄るのですが、その際2つの点が問題となります。

- cargo.tomlの他の項で使える"{{ bin_alias }}"が何故か[submit.transpile]では使えない。
- [submit.transpile]はコマンドを配列で渡すので、パイプ等を使いにくい。

妥協の方法として考えられるのは、LinuxやWSLを前提にシェルスクリプトを書いてしまうことです。（Windowsでも記述が異なるだけで同様）

例えば、bin_nameをもとにCargo.tomlからbin_aliasを得て、提出ファイルをcatする以下のシェルスクリプトを用いればよいです。

シェルスクリプトの権限は777にします。（755でもだめです。）

```bash
#!/bin/bash

grep "^$1" Cargo.toml | sed -e "s/$1 = { alias = \"/.\/src\/bin\//g" -e "s/\".*/.rs/g" | xargs cat
```

あとは以下のように[submit.transpile]を変更すればよいです。

```toml
[submit.transpile]
kind = "command"
args = ["(シェルスクリプト 絶対パスのほうがいいかも).sh", "{{ bin_name }}"]
language_id = "5054"
```

対応させたら https://atcoder.jp/contests/language-test-202301 などで使えるか確認しましょう。

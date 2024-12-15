# Unmarshal JSON files in Bash

Go has functions to *convert* from information from JSON files into Go *structs*.
There's nothing like that in Bash, mostly because Bash does not have *structs* or anything like it.

But I wanted to streamline the process of having a JSON file like:

```json
// dunder.json
{
    "customer": "Dunder Mifflin Scranton",
    "uuid": "3f6b0814-e923-415b-9fd8-db9407e69546",
    "active": true
}
```

And *unmarshal* its values into Bash variables, automatically created from the JSON file's keys, like this:

```console
#!/usr/bin/env bash

source unmarshal.sh

unmarshal dunder.json

msg="Customer $customer (UUID: $uuid) is"

if [[ $active == "true" ]]; then msg="$msg active"; else msg="$msg not active"; fi

echo $msg
```

```console
$ bash demo.sh 
Customer Dunder Mifflin Scranton (UUID: 3f6b0814-e923-415b-9fd8-db9407e69546) is active
```

## Tests

Run `bash tests.sh` to check `unmarshal.sh` agains multiple inputs.

## "Making of"

Please, take a look at the following articles (in spanish) where there's a description of why I developed this *library* and how I solved some of the issues that I found along the way:

- [Unmarshal JSON en Bash (Parte I)](https://onthedock.github.io/post/241005-unmarshal-json-en-bash-i/)
- [Unmarshal JSON en Bash (Parte II)](https://onthedock.github.io/post/241006-unmarshal-json-en-bash-ii/)

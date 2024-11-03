#!/bin/bash

source unmarshal.sh

test_jq_present() {
    # Setup
    cat > doc.json << EOF
    null
EOF

    got=$(unmarshal doc.json)
    exit_code=$?

    if [ $exit_code -eq $ERROR_MISSING_JQ ]; then
        echo "$got"
        exit $ERROR_MISSING_JQ # Stop the test, as Jq is required
    fi
    # Clean up
    unset exit_code got
}

test_unsupported_type_null() {
    # Setup
    cat > doc.json << EOF
    null
EOF

    got=$(unmarshal doc.json)
    exit_code=$?

    if [ $exit_code -eq 1 ]; then echo "[OK] ${FUNCNAME[0]}: $got"; else echo "[KO] ${FUNCNAME[0]}"; fi
    # Clean up
    unset exit_code got
}

test_unsupported_type_string() {
    # Setup
    cat > doc.json << EOF
    "this is a string"
EOF

    got=$(unmarshal doc.json)
    exit_code=$?

    if [ $exit_code -eq 1 ]; then echo "[OK] ${FUNCNAME[0]}: $got"; else echo "[KO] ${FUNCNAME[0]}"; fi
    # Clean up
    unset exit_code got
}

test_unsupported_type_number() {
    # Setup
    cat > doc.json << EOF
    42
EOF

    got=$(unmarshal doc.json)
    exit_code=$?

    if [ $exit_code -eq 1 ]; then echo "[OK] ${FUNCNAME[0]}: $got"; else echo "[KO] ${FUNCNAME[0]}"; fi
    # Clean up
    unset exit_code got
}

test_unsupported_type_bool() {
    # Setup
    cat > doc.json << EOF
    true
EOF
    # Test
    got=$(unmarshal doc.json)
    exit_code=$?

    if [ $exit_code -eq 1 ]; then echo "[OK] ${FUNCNAME[0]}: $got"; else echo "[KO] ${FUNCNAME[0]}"; fi
    # Clean up
    unset exit_code got
}

test_unsupported_type_array() {
    # Setup
    cat > doc.json << EOF
    []
EOF

    got=$(unmarshal doc.json)
    exit_code=$?

    if [ $exit_code -eq 1 ]; then echo "[OK] ${FUNCNAME[0]}: $got"; else echo "[KO] ${FUNCNAME[0]}"; fi
    # Clean up
    unset exit_code got
}

test_valid_empty_doc() {
    # Setup
    cat > doc.json << EOF
    {}
EOF

    _=$(unmarshal doc.json)
    exit_code=$?

    if [ $exit_code -eq 0 ]; then echo "[OK] ${FUNCNAME[0]}"; else echo "[NOT PASSED!] ${FUNCNAME[0]}"; fi
    # Clean up
    unset exit_code got
}

test_valid_single_key_string_doc() {
    # Setup
    want="this is the 'string' that I want"
    cat > doc.json << EOF
    { "mykey" : "$want" }
EOF

    unmarshal doc.json
    got="$mykey"
    exit_code=$?

    if [ $exit_code -eq 0 ] && [[ "$want" == "$got" ]]; then
        echo "[OK] ${FUNCNAME[0]}: got 'mykey' set to '$got'"
    else
        echo "[NOT PASSED!] ${FUNCNAME[0]}"
        echo "     want '$want' but got '$got'"
    fi
    # Clean up
    unset exit_code got
}

test_valid_single_key_number_doc() {
    # Setup
    want=42
    cat > doc.json << EOF
    { "mykey" : $want }
EOF

    unmarshal doc.json
    got="$mykey"
    exit_code=$?

    if [ $exit_code -eq 0 ] && [[ "$want" == "$got" ]]; then
        echo "[OK] ${FUNCNAME[0]}: got 'mykey' set to '$got'"
    else
        echo "[NOT PASSED!] ${FUNCNAME[0]}"
        echo "     want '$want' but got '$got'"
    fi
    # Clean up
    unset exit_code got
}

test_valid_single_key_null_doc() {
    # Setup
    want=null
    cat > doc.json << EOF
    { "mykey" : $want }
EOF

    unmarshal doc.json
    got="$mykey"
    exit_code=$?

    if [ $exit_code -eq 0 ] && [[ "$want" == "$got" ]]; then
        echo "[OK] ${FUNCNAME[0]}: got 'mykey' set to '$got'"
    else
        echo "[NOT PASSED!] ${FUNCNAME[0]}"
        echo "     want '$want' but got '$got'"
    fi
    # Clean up
    unset exit_code got
}

test_valid_single_key_bool_doc() {
    # Setup
    want=false
    cat > doc.json << EOF
    { "mykey" : $want }
EOF

    unmarshal doc.json
    got="$mykey"
    exit_code=$?

    if [ $exit_code -eq 0 ] && [[ "$want" == "$got" ]]; then
        echo "[OK] ${FUNCNAME[0]}: got 'mykey' set to '$got'"
    else
        echo "[NOT PASSED!] ${FUNCNAME[0]}"
        echo "     want '$want' but got '$got'"
    fi
    # Clean up
    unset exit_code got
}

test_valid_single_key_array_doc() {
    # Setup
    want='["one", "two", "three"]'
    cat > doc.json << EOF
    { "mykey" : $want }
EOF

    unmarshal doc.json
    expect=("one" "two" "three")
    exit_code=$?

    if [ $exit_code -eq 0 ] && [[ "${expect[@]}" == "${mykey[@]}" ]]; then
        echo "[OK] ${FUNCNAME[0]}: got 'mykey' set to '${mykey[@]}'"
    else
        echo "[NOT PASSED!] ${FUNCNAME[0]}"
        echo "     want '${expect[@]}' but got '${mykey[@]}'"
    fi
    # Clean up
    unset exit_code got expect
}


test_valid_single_key_array_objects_doc() {
    # Setup
    want='[{"keyone": "valueone"}, {"keytwo": "valuetwo"}, "three"]'
    cat > doc.json << EOF
    { "mykey" : $want }
EOF

    unmarshal doc.json
    expect=('{"keyone":"valueone"}' '{"keytwo":"valuetwo"}' "three")
    exit_code=$?

    if [ $exit_code -eq 0 ] && [[ "${expect[@]}" == "${mykey[@]}" ]]; then
        echo "[OK] ${FUNCNAME[0]}: got 'mykey' set to '${mykey[@]}'"
    else
        echo "[NOT PASSED!] ${FUNCNAME[0]}"
        echo "     want '${expect[@]}' but got '${mykey[@]}'"
    fi
    # Clean up
    unset exit_code got expect
}

test_jq_present
test_unsupported_type_null
test_unsupported_type_string
test_unsupported_type_number
test_unsupported_type_bool
test_unsupported_type_array
test_valid_empty_doc
test_valid_single_key_string_doc
test_valid_single_key_number_doc
test_valid_single_key_null_doc
test_valid_single_key_bool_doc
test_valid_single_key_array_doc
test_valid_single_key_array_objects_doc
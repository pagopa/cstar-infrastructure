 git diff --dirstat=files,0 main | sed 's/^[ 0-9.].*% //g' | grep ".tf\|.tfvars" | tr "\n" " "

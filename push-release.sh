# shellcheck disable=SC2162
read -n 1 -p "Do you want to generate coverage.xml? (Yes/No): " confirm

# shellcheck disable=SC2086
if [ $confirm == "y" ] || [ $confirm == "Y" ]; then

  coverage run -m unittest tests/limiter.py
  coverage xml

  git commit -m "Update coverage.xml"

  read -p "Please enter your codacy project token: " codacy_token

  bash <(curl -Ls https://coverage.codacy.com/get.sh) report -r coverage.xml -t $codacy_token

fi

read -p "Please enter tag: " git_tag
git commit tag "$git_tag"
git push

read -n 1 -p "Do you want to build the project? (Yes/No): " confirm

# shellcheck disable=SC2086
if [ $confirm == "y" ] || [ $confirm == "Y" ]; then

  python3 setup.py sdist bdist_wheel
  twine check dist/*

  read -n 1 -p "Do you want to upload to pypi repository? (Yes/No): " confirm

  # shellcheck disable=SC2086
  if [ $confirm == "y" ] || [ $confirm == "Y" ]; then

    python3 -m twine upload --repository pypi dist/*

  fi

fi

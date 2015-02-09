sudo apt-get update
# don't need to install these yet
#sudo apt-get install -qq -y g++ gfortran valgrind csh
#sudo apt-get install -qq -y g++-multilib gcc-multilib

MINICONDA=Miniconda-latest-Linux-x86_64.sh
MINICONDA_MD5=$(curl -s http://repo.continuum.io/miniconda/ | grep -A3 $MINICONDA | sed -n '4p' | sed -n 's/ *<td>\(.*\)<\/td> */\1/p')
wget http://repo.continuum.io/miniconda/$MINICONDA
if [[ $MINICONDA_MD5 != $(md5sum $MINICONDA | cut -d ' ' -f 1) ]]; then
    echo "Miniconda MD5 mismatch"
    exit 1
fi
bash $MINICONDA -b


PIP_ARGS="-U"

export PATH=$HOME/miniconda/bin:$PATH

conda config --add channels http://conda.binstar.org/omnia
conda create --yes -n ${python} python=${python} --file devtools/ci/requirements-conda-${python}.txt
conda update --yes conda
source activate $python

# Useful for debugging any issues with conda
# conda info -a

# install python pip packages
PIP_ARGS="-U"
$HOME/miniconda/envs/${python}/bin/pip install $PIP_ARGS -r devtools/ci/requirements-${python}.txt

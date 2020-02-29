##### Install dependent packages
sudo mv /etc/apt/sources.list /etc/apt/sources.list.bk
sudo cp sources.list.aliyun /etc/apt/sources.list 
sudo apt-get update
sudo apt-get build-dep r-base

#### Choose R version
RVERSION=3.6.2

#### Download R source code
mkdir src
cd src
wget https://mirrors.tongji.edu.cn/CRAN/src/base/R-3/R-${RVERSION}.tar.gz 
tar zxf R-${RVERSION}.tar.gz
cd R-${RVERSION}

#### Configure, build and install
./configure --prefix=$HOME/R/${RVERSION} --enable-R-shlib
make
make install

#### Remove the source code
# cd ..
# rm -r R-${RVERSION} 

#### Add R to PATH
cd
cp .bashrc .bashrc-R.bk
echo -e "\n# add R $RVERSION to PATH\nexport PATH=$HOME/R/${RVERSION}/bin:\$PATH\n" >> .bashrc
. .bashrc

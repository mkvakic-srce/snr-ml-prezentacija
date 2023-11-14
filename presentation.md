---
title: Korištenje kontejnera na resursima za napredno računanje
author: Sektor za napredno računanje
date: 16. studenog 2023.
output: powerpoint_presentation
monofont: Consolas

---

## Sadržaj

- Kontejneri na resursima za napredno računanje
    - Kontejneri
    - Apptainer

- Primjeri
    - Kontejneri na Supeku
    - "Po narudžbi"
    - MPI
    - Squashfs

# Kontejneri na resursima za napredno računanje

## Kontejneri

:::::: {.columns}
::: {.column}
- [Wikipedia](https://hr.wikipedia.org/wiki/Kontejner)
    - *Prenosivi spremnik normiranih izmjera koju služi za ukrcaj, prijevoz i
       skladištenje robe na putu od proizvođača do odredišta*
- [Docker](https://www.docker.com/resources/what-container)
    - *Standardna jedinica softvera koja pakira kod i sve njegove
       ovisnosti tako da aplikacija radi brzo i pouzdano iz jednog računalnog
       okruženja u drugo.*
- Njihova glavna značajka?
    - **Prenosivost**
:::
::: {.column}
![Slika 1 Kontejner ([izvor](https://upload.wikimedia.org/wikipedia/commons/d/df/Container_01_KMJ.jpg))](images/container.jpg)
:::
::::::

## Kontejneri - virtualizacija

- Virtualizacija
    - podjela fizičkih računarskih resursa u više neovisnih putem *hipervizora*
    - višekorisničko okružje sa zasebnim potrebama
    - osnova današnjeg računarstva u oblaku

- Kontejneri
    - efikasnija i brža od tipične putem "hipervizora"
    - "lightweight" virtualizacija na razini OS-a

- Docker
    - danas svepristuno rješenje
    - temeljeno na LXC tehnologiji
        - *cgroups* - ograničavanje resursa
        - *namespace* - izolacija od domaćina

## Kontejneri - virtualizacija

![Slika 2 VM vs. kontejner (prilagođeno iz *Fig. 1* u [izvoru](https://ieeexplore.ieee.org/document/8950983))](images/vm-container.png)

## Kontejneri - Zašto?

1. Prenosivost
    - mogućnost izvršavanja na sličnim sustavima
1. Lakši razvoj okoline
    - u "potpunoj" kontroli korisnika
1. Dijeljenje i ponovljivost (eng. *reproducibility*)
    - recepti koje bilo tko može koristiti
1. Performanse
    - Linux aplikacija kao i sve ostale

## Kontejneri - HPC

- Zašto ne Docker? (barem u 2017...)
    - iziskuje povišene "root" ovlasti
    - iziskuje dodatne servise ili "docker daemon"
    - nema integraciju sa sustavima za podnošenje poslova
    - nema podršku za MPI i GPU

## Apptainer

:::::: {.columns}
::: {.column}
- Kontejeri prilagođeni HPC-u
    - originalno projekt Singularity (2015. - )
- Značajke
    - zadržavanje korisničkih ovlasti
    - prenosiva slika
    - kompatibilnost s Dockerom
    - integracija sa sustavima PBS, SGE, Slurm...
    - podrška za aplikacije MPI i GPU
:::
::: {.column}
![Slika 3 Apptainer logo](images/apptainer.jpg)
:::
::::::

## Apptainer - Workflow

![Slika 4 Singularity flow ([izvor](https://docs.sylabs.io/guides/2.5/user-guide/singularity_flow.html))](images/singulairty-flow.png)

## Apptainer - Izgradnja

- **`apptainer build ...`**
    - izgradnja i prebacivanje iz jednog u drugi format
- Formati
    1. **image** ili 'read-only' slika za izvršavanje
    1. **sandbox** ili 'read-write' direktorij za uređivanje
- Izvori
    - online repozitoriji u obliku **`docker://[URI]`**
    - definicijske datoteke
    - sandbox direktoriji

## Apptainer - Definicijske datoteke

- Recepti za izgradnju
    1. zaglavlje
    1. odjeljci
- Zaglavlje
    - Izvor i osnovni OS
- Odjeljci
    - **`%files`** - kopiranje datoteka u kontejner
    - **`%environment`** - postavljanje okoline tijekom izvršavanja
    - **`%post`** - naredbe za izvršavanje nakon izgradnje osnove
    - **`%runscript`** - zadana naredba pri izvršavanju kontejnera

## Apptainer - Izvršavanje

- **`apptainer exec/run ...`**
    - **`exec`** - izvršavanje komanda u kontejneru
    - **`run`** - izvršavanje samog kontejnera
- Bitniji argumenti
    - **`--bind`** - spajanje direktorija u kontejner
    - **`--nv`** - omogućavanje GPU podrške

## Apptainer - Interaktivno

- **`apptainer shell ...`**
    - otvori interaktivnu sjednicu unutar kontejnera
- Bitniji argumenti
    - **`--writable`** - upisivanje u kontejner
    - **`--fakeroot`** - izvršavanje unutar kontejnera kao root 

# Primjeri

## Priprema

:::::: {.columns}
::: {.column}
- Primjeri
    - Kontejneri na Supeku
    - "Po narudžbi"
    - MPI
    - Squashfs
- Priprema/git
    - [mkvakic/snr-apptainer-primjeri](https://github.com/mkvakic-srce/snr-apptainer-primjeri)
:::
::: {.column}
```sh
  
# ssh na pristupni čvor GPU
ssh korisnik@login-gpu.hpc.srce.hr
  
# git clone
git clone git@github.com:mkvakic-srce/snr-apptainer-primjeri.git
  
# cd
cd snr-apptainer-primjeri
  
```
:::
::::::

# Kontejneri na Supeku

## Kontejneri na Supeku

- Primjeri
    - Interaktivna izgradnja
    - Izvršavanje putem skripte PBS
    - Izvršavanje na GPU
- Interaktivna izgradnja
    - samo na pristupnom GPU poslužitelju
    - **`/scratch/apptainer`** - staza za izgradnju

## Kontejneri na Supeku - interaktivna izgradnja

<!-- snr-apptainer-primjeri/basic/create.md -->
```sh
   
# spoji se na login GPU
ssh korisnik@login-gpu.hpc.srce.hr
  
# pomakni se u odgovarajući direktorij i kreiraj korisnički
cd /scratch/apptainer
mkdir ${USER}
cd ${USER}
 
# preuzmi Ubuntu 22.04 u sandbox verziji i pokreni interaktivnu sjednicu
apptainer build --sandbox ubuntu-22.04.sandbox docker://ubuntu:22.04
apptainer shell --writable --fakeroot ubuntu-22.04.sandbox
 
# unutar kontejnera: osvježi OS, instaliraj pakete i izađi
Apptainer> apt update -y
Apptainer> apt install python3-pip -y
Apptainer> python3 -m pip install numpy tqdm torch torchvision
Apptainer> exit
 
# pretvori sandbox u image i prebaci u korisnički
apptainer build ubuntu-22.04.sif ubuntu-22.04.sandbox/
mv ubuntu-22.04.sif ${HOME}/.
 
```

## Kontejneri na Supeku - izvršavanje putem skripte PBS

<!-- snr-apptainer-primjeri/basic/run.sh -->
```sh
 
#PBS -q cpu-radionica
#PBS -l ncpus=1
  
cd ${PBS_O_WORKDIR:-""}
  
apptainer exec ${HOME}/ubuntu-22.04.sif python3 run.py
```

## Kontejneri na Supeku - izvršavanje na GPU

<!-- snr-apptainer-primjeri/basic/gpu.sh -->
```sh
 
#PBS -q gpu-radionica
#PBS -l ngpus=1
  
cd ${PBS_O_WORKDIR:-""}
  
apptainer exec --nv ${HOME}/ubuntu-22.04.sif python3 gpu.py
```

# "Po narudžbi"

## "Po narudžbi"

:::::: {.columns}
::: {.column}
- Primjeri
    - Izgradnja condom
    - Izgradnja repozitorijem NGC
    - Izgradnja CRAN-om
- Instalacija ovisnosti upraviteljima knjižnica
    - **`apt/yum install ...`**
    - **`conda/pip install ...`**
    - **`install.package(...)`**
- *Container Registries*
    - Docker Hub - "meka" svih repozitorija
    - Nvidia NGC - NVIDIA kontejneri optimizirani za GPU
    - BioContainers - kontejneri namijenjeni bioinformatici
:::
::: {.column}
![Slika 5 Docker Hub](images/docker-hub.png)
:::
::::::

## "Po narudžbi" - conda

<!-- snr-apptainer-primjeri/custom/conda.* -->
```sh
  
# napravi kontejner
apptainer build conda.sif conda.def
  
# pripremi jezični model
apptainer run conda.sif gpt2-prepare.py
  
# podnesi posao
qsub conda.sh
  
```

## "Po narudžbi" - NGC

<!-- snr-apptainer-primjeri/custom/ngc.* -->
```sh
  
# napravi kontejner
apptainer build ngc.sif ngc.def
  
# podnesi posao
qsub ngc.sh
  
```

## "Po narudžbi" - CRAN

<!-- snr-apptainer-primjeri/custom/r-base.* -->
```sh
  
# napravi kontejner
apptainer build r-base.sif r-base.def
  
# podnesi posao
qsub r-base.sh
  
```

# MPI

## MPI

:::::: {.columns}
::: {.column}
- Dva načina
    - **`hybrid`** - MPI unutar kontejnera
    - **`bind`** - MPI izvan kontejnera
- Cray MPI
    - **`cray-pals`** - PBS na Crayu
    - **`cray-pmi`** - MPICH na PALS-u
    - **`cray-mpich-abi`** - implementacija MPI
    - **`libfabric`** - MPI na Slingshotu
- **`"bind"`** model na Supeku
    - RHEL 8 kompatibilan OS
:::
::: {.column}

![Slika 6 Bind način spajanja kontejnera ([izvor](https://ieeexplore.ieee.org/document/8950983))](images/mpi-bind.png)

:::
::::::

## MPI - hybrid kontejner

<!-- snr-apptainer-primjeri/mpi/hybrid.* -->
```sh
  
# izgradi kontejner
apptainer build hybrid.sif hybrid.def
  
# podnesi posao
qsub hybrid.sh
  
```

## MPI - bind kontejner

<!-- snr-apptainer-primjeri/mpi/bind.* -->
```sh
   
# izgradi kontejner
apptainer build bind.sif bind.def
   
# podnesi posao
qsub bind.sh
  
```

# Squashfs

## Squashfs

:::::: {.columns}
::: {.column}
- Squashfs
    - komprimiran "read only" blok podataka
- **`mksquashfs`**
    - alat za upravljanje
- MNIST
    - Velika količina malih podataka
    - 28 x 28 pixela
    - 60000 slika od 303 bytea
:::
::: {.column}
![Slika 7 Uzorak slika MNIST ([izvor](https://en.wikipedia.org/wiki/MNIST_database))](images/mnist.png)
:::
::::::

## Squashfs

<!-- snr-apptainer-primjeri/squashfs -->
```sh
  
# download
wget -nc https://github.com/myleott/mnist_png/raw/master/mnist_png.tar.gz
 
# untar
tar xvf mnist_png.tar.gz
 
# pretvori direktorij u sliku
mksquashfs mnist_png/ mnist_png.sqsh
  
# učitaj podatke spojene '--bind' argumentom
apptainer exec \
    --bind mnist_png.sqsh:/mnist_png:image-src=/ \
    ${HOME}/ubuntu-22.04.sif \
    python read.py
  
```

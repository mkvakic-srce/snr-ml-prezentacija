---
title: Korištenje kontejnera na resursima za napredno računanje
author: Sektor za napredno računanje
date: 16. studenog 2023
output: powerpoint_presentation
monofont: Consolas

---

## Sadržaj

- Kontejneri na resursima za napredno računanje
    - Kontejneri
    - Apptainer
    - Osnove interakcije
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
:::
::: {.column}
![Slika x Kontejner ([izvor](https://upload.wikimedia.org/wikipedia/commons/d/df/Container_01_KMJ.jpg))](images/container.jpg)
:::
::::::

## Kontejneri i virtualizacija

- Virtualizacija
    - podjela fizičkih računarskih resursa u više neovisnih putem *hipervizora*
    - višekorisničko okružje sa zasebnim potrebama
    - osnova današnjeg računarstva u oblaku

- Kontejneri
    - efikasnija i brža od tipične putem "hipervizora"
    - "lightweight" virtualizacija na razini OS-a
    - oslanjanje na jezgru OS

- Docker
    - danas svepristuno rješenje
    - temeljeno na LXC tehnologiji
        - *cgroups* - ograničavanje resursa
        - *namespace* - izolacija od domaćina

## Kontejneri i virtualizacija

![Slika x VM vs. kontejner ([izvor](https://ieeexplore.ieee.org/document/8950983))](images/vm-container.png)

## Kontejneri i HPC

- Zašto ne Docker? (barem ne u 2017...)
    - iziskuje povišene "root" ovlasti
    - iziskuje dodatne servise ili "docker daemon"
    - nema integraciju sa sustavima za podnošenje poslova
    - nema podršku za MPI i GPU

## Apptainer

## Osnove interakcije

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
[korisnik@x3000c0s25b0n0 ~]$ git clone git@github.com:mkvakic-srce/snr-apptainer-primjeri.git
Cloning into 'snr-apptainer-primjeri'...
...
 
[korisnik@x3000c0s25b0n0 ~]$ cd snr-apptainer-primjeri
 
[korisnik@x3000c0s25b0n0 snr-apptainer-primjeri]$ ls -1
README.md
...
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

## Kontejneri na Supeku - izvšavanje putem skripte PBS

<!-- snr-apptainer-primjeri/basic/run.sh -->
```sh
#PBS -q cpu-radionica
#PBS -l ncpus=1
 
cd ${PBS_O_WORKDIR:-""}
 
apptainer exec ${HOME}/ubuntu-22.04.sif python3 run.py
```

## Kontejneri na Supeku - izvšavanje na GPU

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
![Slika x Docker Hub](images/docker-hub.png)
:::
::::::

# MPI

## MPI

:::::: {.columns}
::: {.column}
- Dva načina
    - **`hybrid`** - MPI unutar kontejnera
    - **`bind`** - MPI izvan kontejnera
- Cray
    - **`cray-pals`** - PBS na Crayu
    - **`cray-pmi`** - MPICH na PALS-u
    - **`cray-mpich-abi`** - implementacija MPI
    - **`libfabric`** - MPI na Slingshotu
- **`bind`**
    - RHEL 8 kompatibilan OS
:::
::: {.column}

![Slika x Bind način spajanja kontejnera ([izvor](https://ieeexplore.ieee.org/document/8950983))](images/mpi-bind.png)

:::
::::::

## MPI - hybrid kontejner

<!-- snr-apptainer-primjeri/mpi/hybrid.* -->
```sh
 
# izgradi kontejner
[korisnik@x3000c0s25b0n0 ~]$ apptainer build hybrid.sif hybrid.def
INFO:    User not listed in /etc/subuid, trying root-mapped namespace
...
 
# podnesi posao
[korisnik@x3000c0s25b0n0 ~]$ qsub hybrid.sh
104421.x3000c0s25b0n0.hsn.hpc.srce.hr
 
```

## MPI - bind kontejner

<!-- snr-apptainer-primjeri/mpi/bind.* -->
```sh
 
# izgradi kontejner
[korisnik@x3000c0s25b0n0 ~]$ apptainer build bind.sif bind.def
INFO:    User not listed in /etc/subuid, trying root-mapped namespace
...
 
# podnesi posao
[korisnik@x3000c0s25b0n0 ~]$ qsub bind.sh
104422.x3000c0s25b0n0.hsn.hpc.srce.hr
 
```

# Squashfs

## Squashfs

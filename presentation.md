---
title: "Aplikacije za strojno učenje na resursu Supek"
author: Sektor za napredno računanje
date: 17. studenog 2023
output: powerpoint_presentation

---

## Sadržaj

- Strojno učenje na Supeku
  - Aplikacije i performanse
  - Python i Lustre
  - Implementacija

- Primjeri
  - TensorFlow
  - PyTorch
  - scikit-learn & Dask
  - Ray

# Strojno učenje na Supeku

## Aplikacije

:::::::::::::: {.columns}
::: {.column width="50%"}

- NVIDIA NGC
    - kontejneri optimizari za izvođenje na GPU
- Trenutne
    - TensorFlow 2.10.1
    - PyTorch 1.8.0, 1.14.0 i 2.0.0
    - Dask 2023.7.0
    - Scikit-learn 0.24.1-2, 1.2.2, 1.30
    - Ray 2.4.0
- U izradi
    - Horovod
    - Rapids
    - Lightning AI

:::
::: {.column width="50%"}

![](images/ml.png)
<!-- Trenutne aplikacije strojnog učenja -->

:::
::::::::::::::

## Performanse - Resnet50

![](images/ml-performance.png)
<!-- Brzina treniranja modela ResNet50 [img/sec] korištenjem PyTorcha (lijevo) i TensorFlowa (desno) na klasteru Supek (plavo) i Isabella (narančasto) -->

## Implementacija

:::::: {.columns}

::: {.column width="50%"}
- Modulefiles
    - **`$IMAGE_PATH`** - definicija staze kontejnera
    - **`$PATH`** - dodavanje wrapper
- Wrapperi
    - Izvršne shell skripte koje osiguravaju integraciju s PBS-om
- Više inačica ovisno o potrebama
    - **`run-singlenode.sh`** - TensorFlow na jednom čvoru
    - **`torchrun-multinode.sh`** - PyTorch na više čvorova
    - **`dask-launcher.sh`** - Dask klaster
:::

::: {.column width="50%" align=bottom}

```bash
#PBS -l ngpus=1
#PBS -l ncpus=8
module load scientific/tensorflow
run-singlenode.sh moja-skripta.py
```

:::

::::::

## NCCL

:::::::::::::: {.columns}
::: {.column width="50%"}

- ["Data parallel" problem](https://siboehm.com/articles/22/data-parallel-training)
    - Usklađivanje gradijenata na više procesora tijekom backpropa
- NCCL
    - NVIDIA MPI
    - NVLink - 600GB/s
- [AllReduce](https://marek.ai/allreduce-the-basis-of-multi-device-communication-for-neural-network-training.htm)
    - Ring & Tree

:::
::: {.column width="50%"}

![](images/nccl.png)
<!-- Ring AllReduce algoritam (Figure 4. u [izvoru](https://www.uber.com/en-HR/blog/horovod/))-->

:::
::::::::::::::
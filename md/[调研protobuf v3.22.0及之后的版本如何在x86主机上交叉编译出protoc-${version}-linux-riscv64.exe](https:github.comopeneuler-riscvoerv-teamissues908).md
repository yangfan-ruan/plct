[调研protobuf v3.22.0及之后的版本如何在x86主机上交叉编译出protoc-${version}-linux-riscv64.exe](https://github.com/openeuler-riscv/oerv-team/issues/908)

https://build.tarsier-infra.isrc.ac.cn/package/show/openEuler:24.03/protobuf 使用了cmake/Ninja进行native构建，但是maven中央仓库上的例如 [protoc-4.27.2-linux-aarch_64.exe](https://repo1.maven.org/maven2/com/google/protobuf/protoc/4.27.2/protoc-4.27.2-linux-aarch_64.exe) 这种除x86外其他架构的文件应该是使用交叉编译生成的。

#### v3.22.0之前

在v3.22.0之前，可以直接apt安装交叉工具链然后使用`protoc-artifacts/build-protoc.sh`脚本来进行交叉编译：
比如对于v3.7.1版本，可以打上[riscv64相关patch](https://github.com/DingliZhang/protobuf/commit/648d55f2d96ed3a5b1ae4b5d430c04a8acb552f1), 并且在x86主机（以ubuntu22.04为例）上交叉构建：

```
sudo apt install -y g++-aarch64-linux-gnu
./protoc-artifacts/build-protoc.sh linux riscv64 protoc
```



#### v3.22.0及之后

protoc-artifacts目录被移除，应该是改用bazel进行构建，上述 build-protoc.sh 脚本进行交叉编译的方法失效。

## 希望的产出

1. 调研 [protoc-4.27.2-linux-aarch_64.exe](https://repo1.maven.org/maven2/com/google/protobuf/protoc/4.27.2/protoc-4.27.2-linux-aarch_64.exe) 或同目录下s390、ppcle等架构的文件是如何构建的
2. 使用1中调研出的方法，构建出v3.22.0版本的protoc-3.22.0-linux-riscv64.exe（注意检查文件大小及格式）

参考issue：
[protocolbuffers/protobuf#17347](https://github.com/protocolbuffers/protobuf/issues/17347)
[protocolbuffers/protobuf#16582](https://github.com/protocolbuffers/protobuf/issues/16582)

所需技能: bazel

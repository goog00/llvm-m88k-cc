//===-- M88kRegisterInfo.td - M88k Register definitions ----*- tablegen -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

class M88kReg<bits<5> Enc, string n> : Register<n> {
  let HWEncoding{15-5} = 0;
  let HWEncoding{4-0} = Enc;
  let Namespace = "M88k";
}

class M88kCRReg<bits<6> Enc, string n> : Register<n> {
  let HWEncoding{15-6} = 0;
  let HWEncoding{5-0} = Enc;
  let Namespace = "M88k";
}

class M88kRegisterClass<list<ValueType> types, int size, int alignment,
                        dag regList, int copycost = 1>
  : RegisterClass<"M88k", types, alignment, regList> {
      let Size = size;
      let CopyCost = copycost;
}

class M88kRegisterOperand<RegisterClass RC> : RegisterOperand<RC> {
  let DecoderMethod = "decode"#RC#"RegisterClass";
}

let Namespace = "M88k" in {
  def sub_hi : SubRegIndex<32, 0>;
  def sub_lo : SubRegIndex<32, 32>;
}

// General-purpose registers
foreach I = 0-31 in {
  let isConstant = !eq(I, 0) in
    def R#I : M88kReg<I, "r"#I>;
}

def GPR : M88kRegisterClass<[i32, f32], 32, 32,
                            (add (sequence "R%u", 0, 31))>;
def GPROpnd : M88kRegisterOperand<GPR> {
  let GIZeroRegister = R0;
}

// Register class representing a pair of even-odd GRs.
def GRPair : RegisterTuples<[sub_hi, sub_lo],
                            [(add (sequence "R%u", 0, 30, 2)),
                             (add (sequence "R%u", 1, 31, 2))]>;

def GPR64 : M88kRegisterClass<[i64, f64, v8i8, v4i16, v2i32], 64, 32,
                              (add GRPair), 2>;

def GPR64Opnd : M88kRegisterOperand<GPR64>;



// Control registers.
foreach I = 0-63 in {
  def CR#I : M88kCRReg<I, "cr"#I>;
}

// Carry bit. This is really bit 28 of the processor status register aka cr1.
def CARRY: M88kCRReg<1, "carry"> {
  let Aliases = [CR1];
}

foreach I = 0-63 in {
  def FCR#I : M88kCRReg<I, "fcr"#I>;
}

let isAllocatable = 0 in {
  def CR : M88kRegisterClass<[i32], 32, 32, (add (sequence "CR%u", 0, 63))>;
  def FCR : M88kRegisterClass<[i32], 32, 32, (add (sequence "FCR%u", 0, 63))>;
}
def CROpnd : M88kRegisterOperand<CR>;
def FCROpnd : M88kRegisterOperand<FCR>;

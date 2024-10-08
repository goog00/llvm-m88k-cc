//===-- M88kCallLowering.h - Call lowering ----------------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
/// \file
/// This file implements the lowering of LLVM calls to machine code calls for
/// GlobalISel.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_LIB_TARGET_M88K_GISEL_M88KCALLLOWERING_H
#define LLVM_LIB_TARGET_M88K_GISEL_M88KCALLLOWERING_H

#include "llvm/ADT/ArrayRef.h"
#include "llvm/CodeGen/GlobalISel/CallLowering.h"
#include "llvm/CodeGen/Register.h"

namespace llvm {
class Value;
class M88kTargetLowering;

class M88kCallLowering : public CallLowering {

public:
  M88kCallLowering(const M88kTargetLowering &TLI);

  bool lowerReturn(MachineIRBuilder &MIRBuilder, const Value *Val,
                   ArrayRef<Register> VRegs, FunctionLoweringInfo &FLI,
                   Register SwiftErrorVReg) const override;

  bool lowerFormalArguments(MachineIRBuilder &MIRBuilder, const Function &F,
                            ArrayRef<ArrayRef<Register>> VRegs,
                            FunctionLoweringInfo &FLI) const override;
  bool enableBigEndian() const override { return true; }
};

} // end namespace llvm

#endif // LLVM_LIB_TARGET_M88K_GISEL_M88KCALLLOWERING_H

import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:verzel_app/app/common/styles/app_styles.dart';
import 'package:verzel_app/app/common/widget/app_widgets.dart';
import 'package:verzel_app/app/common/widget/input_text.dart';
import 'package:verzel_app/app/layers/presenter/providers/data_provider.dart';
import 'package:verzel_app/app/layers/presenter/screens/not_logged_in/login/login.dart';
import 'package:verzel_app/navigation.dart';

class RegisterScreen extends StatefulWidget {
  final Map<String, dynamic>? registerCar;
  const RegisterScreen({
    Key? key,
    this.registerCar,
  }) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  Map<String, dynamic>? register;
  final appStyles = AppStyles();
  final appWidgets = AppWidgets();
  TextEditingController nome = TextEditingController();
  TextEditingController marca = TextEditingController();
  TextEditingController modelo = TextEditingController();
  TextEditingController ano = TextEditingController();
  TextEditingController cidadeBrasileira = TextEditingController();
  TextEditingController kilometragem = TextEditingController();
  TextEditingController valor = TextEditingController();
  List<Map<String, dynamic>> evidences = [];

  late DataProvider dataProvider;
  late Future<void> future;

  Future<void> initScreen() async {
    dataProvider = Provider.of<DataProvider>(context, listen: false);
    await Future.delayed(const Duration(milliseconds: 200));
    if (widget.registerCar == null) {
      register = {};
      register!['bytes'] = appWidgets.base64ToUint8List(
          'iVBORw0KGgoAAAANSUhEUgAAAgAAAAIACAYAAAD0eNT6AAAABHNCSVQICAgIfAhkiAAAAAFzUkdCAK7OHOkAAAAEZ0FNQQAAsY8L/GEFAAAACXBIWXMAAA7EAAAOxAGVKw4bAAAAGXRFWHRTb2Z0d2FyZQB3d3cuaW5rc2NhcGUub3Jnm+48GgAAJ+NJREFUeF7t3Qn4ndOdB/AjISSWWCKxRDRCxVa7McYelKrETg3azjB0TDtl1D52hqqph1qq2lrqKanGkqKWGftSilgjIwRB7K0tRDTG73W0EVnufe9/S87n8zz3yXvO/5+4773e+37v+57zO3N9/IkEABSlW/4TACiIAAAABRIAAKBAAgAAFEgAAIACCQAAUCABAAAKJAAAQIEEAAAokAAAAAUSAACgQAIAABRIAACAAgkAAFAgAQAACiQAAECBBAAAKJAAAAAFEgAAoEACAAAUSAAAgAIJAABQIAEAAAokAABAgQQAACiQAAAABRIAAKBAAgAAFEgAAIACCQAAUCABAAAKJAAAQIEEAAAokAAAAAUSAACgQAIAABRIAACAAgkAAFAgAQAACiQAAECBBAAAKJAAAAAFEgAAoEACAAAUSAAAgAIJAABQIAEAAAokAABAgQQAACiQAAAABRIAAKBAAgAAFEgAAIACCQAAUCABAAAKJAAAQIEEAAAokAAAAAUSAACgQAIAABRIAACAAgkAAFAgAQAACiQAAECBBAAAKJAAAAAFEgAAoEACAAAUSAAAgAIJAABQIAEAAAokAABAgQQAACiQAAAABRIAAKBAAgAAFEgAAIACCQAAUCABAAAKJAAAQIEEAAAokAAAAAUSAACgQAIAABRIAACAAgkAAFAgAQAACiQAAECBBAAAKJAAAAAFEgAAoEACAAAUSAAAgAIJAABQIAEAAAokAABAgQQAACiQAAAABRIAAKBAAgAAFEgAAIACCQAAUCABAAAKJAAAQIEEAAAokAAAAAUSAACgQAIAABRIAACAAgkAAFAgAQAACiQAAECBBAAAKJAAAAAFEgAAoEACAAAUSAAAgAIJAABQIAEAAAokAABAgQQAACiQAAAABRIAAKBAAgAAFEgAAIACCQAAUCABAAAKJAAAQIEEAAAokAAAAAUSAACgQAIAABRIAACAAgkAAFAgAQAACiQAAECBBAAAKJAAAAAFEgAAoEACAAAUSAAAgAIJAABQoLk+/kTeBmp6+OGHq8fLL7+cJkyYUP352muvpY8++ij/BtMz99xzp759+6Yll1zyr4/11lsvrbDCCvk3gPYiAEANcWK//fbb09VXX109nnvuufwT2sLKK6+cdthhh7T99tunddZZJ/cCbUkAgCZMmTIlXXTRRemYY45J48ePz720pzXXXDOdeuqpacstt8w9QFsQAKBB11xzTTriiCPS448/nnvoSFtssUUVBNZaa63cA7RCAIBZeO+999Lee++dRowYkXvoLHPNNVc6+uijqyswsQ3UJwDATIwbNy4NGzYsPfroo7mHrmCnnXaqbsXMP//8uQdolgAAM3DbbbdVJ5o33ngj99CVrLHGGtVtmWWWWSb3AM0QAGA64hv/BhtskN59993cQ1cUswXuvvvu1Lt379wDNEohIJjG66+/noYOHerkPxt44okn0q677qreAtQgAMBUJk+eXF32f/bZZ3MPXd2NN96Yvvvd7+YW0CgBAKZywgknVAV+mL2cd955VUEmoHHGAEAW5XuXX375atofs5/Bgwenxx57LHXv3j33ADMjAEC2//77p5/+9Ke51boFFljANLVZiFsub775Zm617vzzz0/77rtvbgEzIwDAJ8aMGZNWXXXVlgaTDRo0KO21115p9dVXT1/5ylfSwIEDFatpwKuvvlotpPTII4+kkSNHVtMv61pqqaXS2LFjU8+ePXMPMCMCAHziwAMPTGeccUZuNadbt27VILSTTz459erVK/dS189+9rN08MEHp7fffjv3NGf48OFpl112yS1gRgwChE9EQZk6+vTpUw0ajPDg5N824hJ+3MuPZYHriKsIwKy5AkDxYnGfuPxfx+WXX17NQ6ftPf3009WtlIkTJ+aexiy22GLplVdeMRgQZsEVAIpXd/pYrFfv5N9+YkzF8ccfn1uNi9LNUR0QmDkBgOLdeeedeatxcbn/3HPPzS3ay/e///3qKkCzBACYNQGA4r300kt5q3FxUurXr19u0V7iMv4WW2yRW42r855CaQQAijdhwoS81biY6kfHWHPNNfNW4+q8p1AaAYCixbz/1157LbcaV+eyNPXEsr/NEgBg1gQAihZFaOpMhFlxxRXzFu0tSvw2K2YBADNnGiBtYvTo0VU1t7j3OvUjvolNmjQp/1bXE1cAXnzxxdxq3C233JI23XTT3KK9NVtRMcYO9O/fP7e6pnnnnTctueSSVfXCqR9xe2mllVbKvwXtRwCglilTplQjrWMKXTyeeuqp/JMyCAAdq7SSyiussEIaNmxY9dhggw2qapPQ1gQAmhLf6E866aSq3Gqde+dzCgGgY5W8psLiiy9e1Zs48sgjqysG0FbEShoSS+Qed9xx1TeTs88+u+iTP3SkONbimItjL45By1XTVgQAZiou9f/85z+vPnyOPfZYHz7QSeLYi2MwjsU4JuPYhFYIAMzQn/70pzRkyJC0zz77mFYFXUQci3FMxrEZxyjUJQAwXePGjasGH9166625h6nNN998eYuOECPm+bw4NuMYjWMV6hAA+II//OEPaf31109PPvlk7mFqMSBt5ZVXzi06Qt3VGud0cYzGsRrHLDRLAOBzYl38zTbbrCqQw/Qtv/zyaaGFFsotOsJaa62Vt5hWHKtxzMaxC80QAPirP/7xj2n33XdP77//fu5heg444IC8RUfZb7/90txzz51bTCuO2d122y3dc889uQdmTQCgElX7ouiIk//Mbbzxxul73/tebtFR1l577XTYYYflFtPzwQcfVMfwM888k3tg5gQAqpP+9ttvX4UAZmzHHXdMv/nNb4ouStOZjj766HTUUUe5EjATUTNg2223NTuAhqgESPrGN76RLrvsstxiaoMGDUrrrrtu2mWXXaoAQOcbNWpUOuecc9L999+fHnvssWo9Bz4vxgTceOONwhIzJQAU7qqrrko77LBDbrUmBsZts802aeutt04DBw6sypYuscQSqUePHvk3Zi9Rf312fe6liJP/7BoAopBPDOCLef2xIFWUlx45cmQaP358/o3WnHnmmem73/1ubsEXCQAFiw/OmF41ZsyY3FNPrNceJUrj5D/PPPPkXqCOGIx74oknVotstWKxxRZLY8eOTQsvvHDugc8zBqBg559/fksn//iGf+mll6YHH3wwDR061Mkf2sA666xTXZm78847W5r++MYbb1QLd8GMuAJQqHfeeaeaz153vn98MMW846WXXjr3AG0tRvZH2d8I2nVEBcXRo0dXt+RgWq4AFOq0006rffLfbrvt0h133OHkD+0sSk7/6le/Sscff3zuac6kSZOqmRMwPa4AFCje8mWWWaYaeNSs9dZbL912221q4UMHi/oTZ511Vm41Lo7VmB64wAIL5B74lCsABbrvvvtqnfwjNMTAJCd/6Hg//vGPqxk2zYrbCL///e9zC/5GACjQiBEj8lZzzj333GpaH9Dxunfvni688MI0//zz557GxaBCmJYAUKArr7wybzVuo402qiqMAZ2nX79+6aCDDsqtxl177bVp8uTJuQWfMgagMFE5bbXVVsutxsWgvw033DC3gM7y9ttvpy996UtNl/uNyoBbbrllboErAMW5/fbb81bjll12WSd/6CKi4mbU3WhWjP2BqQkAhXnhhRfyVuPqfNgA7afOMRklh2FqAkBh6gQA9/6ha/nqV7/a9EI/AgDTEgAKUycArLDCCnkL6ApiJkCU4m7Gyy+/nLfgUwJAYeoEgGY/aID21+xx6QoA0xIACtNsAOjdu3fq2bNnbgFdhQBAq0wDLMxcc82VtxoT845dOpy9/PnPf67es1jwadpHWHDBBb/wiAJPlo1tzvvvv59GjRpVLd/76KOPVlPz1l577erRp0+f/FvtZ/fdd0+XX355bjXGxz1TEwAKIwDMOWIxp4ceeqha7e3JJ5/86+OVV17Jv9GceK8HDx7818dKK62U1lxzzdS3b9/8G4Sf//zn6cwzz0yPP/54+stf/pJ7Py+mzu60007phBNOSL169cq9bUsAoFUCQGEEgNnXm2++WS3EdMstt6T//d//rU5AHWGVVVZJm2++edpss83SJptskhZddNH8k7KMHz8+7bvvvumGG27IPbM2aNCg9Mtf/rKqpNnWBABaJQAURgCYvTz//PPVcrBXXHFFevjhh9OUKVPyTzpHt27d0uqrr5523nnntOeee6YBAwbkn8zZfvGLX6QDDzywqsLXrDjmYiW/H/7wh6lHjx65t3UCAK0SAAojAHR97777bnXCv/jii9Ott97aZT+04/+lTTfdNO29995VIJhTl5u96aab0lZbbZVb9R1++OHp5JNPzq3WCQC0yiwA6CL+7//+L/3TP/1TFbq+/e1vV5f6u/IHdjy3eI7xXOM5x3OPfZiTxMDJffbZJ7daE1cAlOOlKxEAoJPFCPL4NheD7uJ+8cSJE/NPZh/xnOO5xz7EvsQ+zQl+8IMfVLdh2kIMGPzWt76VJk2alHugcwkA0EkefPDBtMMOO1T31ONSbmff328LsQ+xL7FPsW+xj7Oru+66K/30pz/NrbYRMzZOOumk3ILOJQBAB3vjjTeq0eTrrLNOuuqqq+bI+7KxT7FvsY+xr7HPs5vrrrsub7WtWJsfugIBADpInBRjDvmKK66YLrjggjnyxD+t2MfY19jn2PfZaZ+jwE97iNsjbgPQFQgA0AFiCt8//MM/VAPKZsdvw62KfY59j9cgXovZwQMPPJC32tbkyZPTI488klvQeQQAaGdRNW699dZL99xzT+4pV7wG8VrEa9KVjRs3rl2DWntdXYBmCADQTqIm/4477pj+/d//PX344Ye5l3gt4jWJ1yZeo64oyiy3p/b+96ERAgC0g/vvvz+ttdZa6corr8w9nS8K9zRbCKo9xWsTr1G8Vl3Naqutlrp3755bbW+NNdbIW9B5VAIsjEqA7S/mw++///4d+q1/8cUXTwMHDqyWiI2V/eLPabfjvYzDPZaFfemll9KLL774uT8/246a9x1ZiyDK45533nlVQaGuZNVVV2239RbiNe7fv39u1aMSIK0SAAojALSv//qv/0pHHHFEbrWv+JY6dOjQNGzYsGq6XVt9u4/gEiWIr7766uoRoaAjRJncKJfbVUTRnosuuii32k5bHVMCAK1yCwDaQBTAiQVf2vPkP/fcc1er8p1xxhnpmWeeqUaSn3jiiWnddddt00v78Y08at+fffbZ1TfVuER/1FFHVYGjPcVrF69hVymIFKGqPbTXvwvNcgWgMK4AtL34xrzXXnul4cOH5562NWTIkKrO/te+9rW08MIL597OEcEjrgrEbY72Kve76667pksuuaRNV86r46233qpuA7zwwgu5p3WxmuLtt99eTYdslSsAtMoVAGjBRx99VK2E1x4n/zXXXDPdeOON6eabb0577LFHp5/8w3LLLVctiztq1KhqtcJll102/6TtxGsZr2nUzu9MvXv3rooYtaWDDjqoTU7+0BYEAGhBlLkdOXJkbrWNGMx36aWXVoVottxyy9zbtcQ32bjqMWbMmHT66aenRRddNP+kbcRrut9+++VW5/nqV7/aZqsBrrzyyumEE07ILeh8AgDUdMghh6QLL7wwt1rXp0+f6v7+k08+WX3jb8v7+u1l3nnnrb7VPv300+nQQw9NPXv2zD9pXZQOjrEHnS0CzuDBg3OrngUXXLAaUDjffPPlHuh8AgDUECeF0047LbdaEyfNGAAXJ9EokNPZ977riNsTp5xySnrqqaeq8QptNYc+Vs77yU9+kludY6GFFqquxsQAxTqhLAZuxngJg//ocmIQIOWIt7yZR79+/fLf5DPDhw//+JMTwXRfr2Yf/fv3//iTk0v+l+ccN99888eLLbbYdPe52Ue3bt0+HjlyZP6XO9ett9768cCBA6f7PKd99OrV6+Ozzjrr4ylTpuS/3bZ222236f53Z/aAqZkFUBizAFozduzYtPbaa6e3334799S3/vrrV9XwoljPnCjq6UeNgraYLRBjDB566KE0YMCA3NN53nvvvXTNNddU9fzj8eCDD6Z33303zTPPPGmVVVapvunH/yPbbLNNuwyS/IxZALRKACiMAFBfTPf7+7//++oDv1V77713Ov/886t76HOyOFl+85vfTL/97W9zT33x2scUuqiH0JVE3YJnn302Lb300h36fgoAtMoYAGjQwQcf3PLJP0bPx9iBGBA2p5/8w/zzz59+85vfpOOPP77lQY2xkmBHVVlsRrynMT2yhPeTOYsAAA2IS/VnnXVWbtUTg8lielsEiZLEif8///M/01VXXVWNhm/Fj370o3TttdfmFtAKAQBm4c0330z/8i//klv1xOXhe++9t6rmV6pYtyBeg1YWwYlL2FF7oS3GYEDpBACYhVig5vXXX8+t5sXc7/j2u9JKK+WeckUxnCgl3Eq9gFjN8JhjjsktoC4BAGbivvvuSz/72c9yq574++aA/81aa63VcgGluB3z8MMP5xZQhwAAMxCju7/zne+0NHL6P/7jP9Kee+6ZW3wmFvyJcQF1xToB//qv/2pUO7RAAIAZOPfcc1sa9R9L6p566qm5xbSOO+64tMMOO+RW8+6+++5qVUKgHgEApmPixInVCaquQYMGpcsuu6zNSuLOiWJ2QCz7u/rqq+ee5sVYgKjPADRPAIDpOO+889Jrr72WW82JqW4x0G2RRRbJPcxI1AmI12rxxRfPPc2JtfqjpgLQPAEApjFp0qRqvnldsYZ8lISlMVEuN4oF1RWLEH300Ue5BTRKAIBpxDK0MdWsjo022qga4EZzNtlkk7TLLrvkVnOeeeaZ9Otf/zq3gEYJADCVyZMntzRwz6C/+mLp37p1/k8++eRq1gbQOAEApjJixIj0/PPP51Zztt9++2rBGupZYYUV0j777JNbzXnyySfTDTfckFtAIwQAmMrFF1+ct5oTo/3jWyitiVH9vXr1yq3m1H3voFQCAGSvvvpquvHGG3OrOd/61reU+m0DSyyxRDrwwANzqzkxm8AaAdA4AQCyGEhWZzR51Po/9thjc4tWHXLIIWmxxRbLrca9//77Lc0mgNIIAJBFUZo6vve977W0wh2fF8smH3nkkbnVHLcBoHECAHxizJgx6YEHHsitxsX96sMOOyy3aCtR579fv3651bg77rij9iBOKI0AAJ+oO4I86v2r+Nf25p133jRs2LDcalwsDnTTTTflFjAzAgB84tZbb81bzYmpf7SPoUOH5q3m3HLLLXkLmBkBgOLFt8bbbrsttxoXU/++/vWv5xZtbciQIdVaAc0SAKAxAgDFe+SRR9Kbb76ZW42Lsr91RqvTmJhdEbdYmvXSSy9VYzqAmRMAKJ7L/12X2wDQfgQAinfnnXfmreYIAO0vbrF069b8x1Td9xRKIgBQvKgj36w111yzWsaW9tWnT5+0wQYb5FbjnnjiibwFzIgAQNFiBbmnnnoqtxrn23/HqXMbIMYAxOBOYMYEAIr27LPPpkmTJuVW4zbffPO8RXvbbLPN8lbjJk6cmMaPH59bwPQIABSt7mjxZZZZJm/R3uqWWR49enTeAqZHAKBodQLAXHPNlZZccsncor317du3qrnQrDpjO6AkAgBFGzduXN5qXMz979GjR27R3mIWQJ11AZ555pm8BUyPAEDR6qwfv/TSS+ctOkqdKy513lsoiQBA0d5555281billloqb9FR6rzmdd5bKIkAQNEEgNlDnSsAAgDMnABA0eqcJNwC6HiuAEDbEwAomisAswdXAKDtCQAU7f33389bjVtiiSXyFh2lzmte572FkggAFK1Xr155q3G+Wc4e6ry3UBIBgKItuOCCeatxsd48HavOt/k67y2URACgaHVOEhMmTMhbdJQPPvggbzVuoYUWylvA9AgAFK3OScIVgI5XJwC4AgAzJwBQNFcAZg91xl0IADBzAgBF6927d95qnCsAHa/Omg113lsoiQBA0ZZffvm81ThXADre2LFj81bjBg0alLeA6REAKNrgwYPzVuMmTpyY3nrrrdyiIzz11FN5q3Errrhi3gKmRwCgaCuttFLeao6rAB1n8uTJ6fnnn8+txgkAMHMCAEWLErN1ZgKMGjUqb9HeHnjggfSXv/wltxoz//zzp/79++cWMD0CAMWrcxvgmmuuyVu0t6uvvjpvNW6FFVZIc801V24B0yMAULxVVlklbzXu+uuvTx999FFu0Z7qBIA67ymURgCgeBtvvHHeatyf//zndPvtt+cW7SUG/40ePTq3GrfRRhvlLWBGBACKt9lmm+Wt5tT5ZkpzrrrqqrzVnE033TRvATMiAFC8ZZddNi233HK51TjjANpfnZAVAzvNAIBZEwDgE3WuAjz77LPp0UcfzS3a2quvvpruueee3Gqcb//QGAEAPuE2QNczcuTINGXKlNxqnAAAjREA4BNbbrllmnvuuXOrcQJA+6nz2sbUv6233jq3gJkRAOATffv2TVtttVVuNe6Pf/yj2QDt4IknnkjXXXddbjUuZnQMGDAgt4CZEQAg23vvvfNWcw499NC8RVuJ17TZ6n9hr732ylvArAgAkA0bNqzWErL33ntvGjFiRG7Rqttuuy397ne/y63GzTfffGnnnXfOLWBWBADI4gSyyy675FZzjjjiCJUB28DHH3+cfvCDH+RWc4YOHVorwEGpBACYyje/+c281ZwxY8akX/ziF7lFXcOHD0/3339/bjWn7i0cKJUAAFPZcMMN07rrrptbzTn22GPTxIkTc4tmffjhh9WVlDpWXnnl9LWvfS23gEYIADCNo446Km81Z8KECemMM87ILZp1zjnnpGeeeSa3mnPkkUda/Q+aJADANLbbbrv0la98Jbeac+qpp6bXXnstt2hULK504okn5lZzll9++bTbbrvlFtAoAQCmEd8k4xtlHW+//Xb6xje+YUBgE6La3x577JHeeOON3NOcww8/PHXv3j23gEYJADAdMZ1s8ODBudWc//mf/0kHHXRQbjErhxxySLr++utzqzmxkJO5/1CPAADT0a1bt3TKKafkVvPOOuusdMEFF+QWM3LRRRel008/PbeaF+/RPPPMk1tAMwQAmIEoDPT1r389t5p3wAEHpDvvvDO3mFas9LfffvvlVvOGDBmSdt9999wCmiUAwEyceeaZqWfPnrnVnJjWttNOO6Xnn38+9/CZ8ePHpx122CFNmjQp9zSnR48e6eyzz84toA4BAGZi4MCBteemh1jTPq4kqA/wN/FaxGvyyiuv5J7mHXzwwWnFFVfMLaAOAQBmIUrTfvnLX86t5o0aNaqqUldncZs5TbwGUW3xoYceyj3N+9KXvlR7lgbwNwIAzMK8886bLr744pYGm/32t7+tKtX96U9/yj3liX2P1+CKK67IPc2L6X6XXHJJ6tWrV+4B6hIAoAF/93d/19KsgHDjjTem9dZbr1rrvjSxz7Hv8Rq04vjjj6/KNQOtEwCgQTG3P6oEtmLs2LFp/fXXT1dffXXumfPFvsY+x763Ysstt0yHHXZYbgGtEgCgCRdeeGEaMGBAbtXzzjvvVCPg49tsLH87p4p9i32MfY19bsUSSyyRfvWrX1X1GYC24WiCJiy66KLp8ssvT/PNN1/uqSdOjsccc0xVcfDdd9/NvXOO2KfYt9jHVkNOjL349a9/nfr27Zt7gLYgAECT4nL2pZde2ibfRkeMGFH9e3fccUfumf3FvsQ+xb61KtZliAGYm266ae4B2ooAADXsuOOObVaI5vHHH08bb7xxVXXw0Ucfzb2zn3jusQ+xL7FPbSEKMan2B+1DAICa9t9//+oSd1u59tpr0xprrFHNk3/uuedyb9cXzzWeczz32Ie2ctRRR6V/+7d/yy2grQkA0IJjjz22CgJtJZbGjUveUeUuZh3UXSK3I8Rzi+cYzzWeczz3thJrBJxwwgm5BbQHAQBadM4557T58r9RI//HP/5xGjRoUDrppJPSSy+9lH/S+eK5xHOK5xbPsW49/xmJMr/nnntubgHtZa6P5+R5SHxBDKpqRr9+/dLLL7+cW8zMD3/4w3TooYfmVtuK9y0K6Wy//fbVY/DgwfknHePJJ59MV111VfW477772mX6Yuzjj370ozYPU3OqGBsRM1Ka4eOeqQkAhREA2tcvf/nLtO+++7Z73f+47B5BIObYRzBo9n2dlfhYiBP9lVdeWZ30x4wZk3/SPmKqX7x2//iP/5h7mBUBgFYJAIURANrfyJEj0x577NFh8/uXXHLJtO2221aX5Jdeeum01FJLVY/YXmihhfJvTd/bb7+dXnzxxeqyfjxi++mnn64G802YMCH/VvtaeOGFqxPZVlttlXtohABAqwSAwggAHSO+Me+2227p4Ycfzj2dY/755/9cKAhTn+zfe++9qq+zxNWLOInFCn80RwCgVQJAYQSAjvPBBx+kAw88MJ133nm5h6nFa3Pqqae2tMpiyQQAWmUWALSTKBcco9njQ3pWl+JLssgii1TjCv77v//byR86kQAA7WzXXXdNjzzySBo6dGjuKVfcFnnsscfSsGHDcg/QWQQA6ADLLrtstSzuNddcU+T97pi1cNNNN6XLLrvsr2MRgM4lAEAH2m677dITTzyRjjzyyNSjR4/cO+fq2bNnOvHEE6srIFtssUXuBboCAQA62GcnxdGjR6d//ud/niPvg/fq1St9//vfT2PHji0m7MDsRgCATrLccsulCy64oDpJHnDAAdWgwdndggsuWFVDHDduXFUm2OV+6LoEAOhkAwYMSD/5yU+qk2bUwe/Tp0/+yewjxjgcd9xx1cqAp5xySurbt2/+CdBVCQDQRSyxxBLptNNOq4r0xGDBXXbZJc0777z5p11PfNv/9re/nW655ZYqvBx99NHVFD9g9qAQUGEUApq9vPXWW2n48OHpiiuuSHfddVenV+5bdNFF0yabbJJ23nnnah2CGM9A51AIiFYJAIURAGZfkydPTvfff3/1jfvWW29Nd999d5o4cWL+afuIAkYbbbRR2nzzzdNmm22WVl999dStmwuHXYEAQKsEgMIIAHOODz/8sFpzIJbqjT+nfsQiP83o3bt3tcTw1I+VVlopLb/88ql79+75t+hKBABaJQAURgAoQ6xD8M4773zhEeLe/bSPOWEGQmkEAFolABRmgQUWaOo+cvz+ZycOoOuIqzbNXOmJoNfslSHmbG7mFSbWjm9GrGnfUevaA42JY7LZk3n//v3zFnxKAChMswEgTJgwIW8BXUGdY1IAYFoCQGFirnmzonY90HXUOSYFAKYlABSmzhWAkSNH5i2gK6hzTAoATEsAKEyd2uy/+93vjB6GLiKOxTgmm7XMMsvkLfiUAFCYDTfcMG817pVXXknXXnttbgGdKY7FOCabNWTIkLwFnzINsDBTpkyprgI0+wGy6qqrpocfflgVOOhEcfxGNcbHHnss9zQm/s6oUaNyCz7l07wwcQIfOnRobjUuPnAuuuii3AI6QxyDzZ78w4477pi34G9cASjQddddl7bddtvcalzUhb/33nurErFAxxo9enRaf/31axXzeeSRR9Jqq62WW/ApAaBAkyZNSosvvnitCn+DBg1K9913X7UqHNAx3nzzzbTeeuulp59+Ovc0LtZzeOqpp3IL/sYtgALFGvN77rlnbjUnPoC22Wab9Oqrr+YeoD3FsRbHXJ2Tf/jOd76Tt+DzXAEoVHyoxDeDunX+l1122WoussuK0H4effTRtN1226Xnnnsu9zRn4MCB1a2DCP0wLVcACtW3b990+OGH51bz4gNpgw02SCeffHK7r0kPpYljKo6tOMbqnvxD/BtO/syIKwAFiyVjv/zlL6fx48fnnnqiuuBhhx2Wdt1111qlhoFPxdLbw4cPT6ecckrLa3Csu+666Q9/+EPTS4BTDgGgcJdeemnt8QDTig+aGKi09dZbV5ceIxhEIOjRo0f+DeAzH374YXXCjxP9uHHj0u9///tqgG1bfSTfdtttaeONN84t+CIBoHDx9u+xxx7psssuyz3A7O6ggw5Kp59+em7B9AkAVNMCN99883T33XfnHmB2FTMGYq0AVTuZFQGAyuuvv14VGak71QjofFGkK4p1RdEumBURkUqfPn2qRUYWWWSR3APMTqI4V0zNdfKnUQIAf7Xiiium66+/PvXr1y/3ALODCPBR4jsqdUKj3ALgC55//vmq+EjUDwe6tpjK6+RPHa4A8AUDBgxId911V61VA4GOs9FGG6V77rnHyZ9aBACma4EFFkhXXnllVS2we/fuuRfoKvbaa6900003WZiL2gQAZiimEUUp0ahH7moAdA1rrLFGuvnmm9PFF1+szC8tEQCYpZhadPXVV1eVxaLSH9Dx+vfvny688ML0wAMPpCFDhuReqM8gQJo2YsSIdMkll6Qbbrghvf/++7kXaA9rr7122n333dMBBxyQevbsmXuhdQIAtcWKZTFtMAJB1BB466238k+AuuaZZ5606aabpmHDhlW33pZZZpn8E2hbAgBtIhY2GTNmTHrhhRc+93jxxRerVQeBz4v797Fg1lJLLfW5R9xy6927d/4taD8CAAAUyCBAACiQAAAABRIAAKBAAgAAFEgAAIACCQAAUCABAAAKJAAAQIEEAAAokAAAAAUSAACgQAIAABRIAACAAgkAAFAgAQAACiQAAECBBAAAKJAAAAAFEgAAoEACAAAUSAAAgAIJAABQIAEAAAokAABAgQQAACiQAAAABRIAAKBAAgAAFEgAAIACCQAAUCABAAAKJAAAQIEEAAAokAAAAAUSAACgQAIAABRIAACAAgkAAFAgAQAACiQAAECBBAAAKJAAAAAFEgAAoEACAAAUSAAAgAIJAABQIAEAAAokAABAgQQAACiQAAAABRIAAKBAAgAAFEgAAIACCQAAUCABAAAKJAAAQIEEAAAokAAAAAUSAACgQAIAABRIAACAAgkAAFAgAQAACiQAAECBBAAAKJAAAAAFEgAAoEACAAAUSAAAgAIJAABQIAEAAAokAABAgQQAACiQAAAABRIAAKBAAgAAFEgAAIACCQAAUCABAAAKJAAAQIEEAAAokAAAAAUSAACgQAIAABRIAACAAgkAAFAgAQAACiQAAECBBAAAKJAAAAAFEgAAoEACAAAUSAAAgAIJAABQIAEAAAokAABAgQQAACiQAAAABRIAAKBAAgAAFEgAAIACCQAAUCABAAAKJAAAQIEEAAAokAAAAAUSAACgQAIAABRIAACAAgkAAFAgAQAACiQAAECBBAAAKJAAAAAFEgAAoEACAAAUSAAAgAIJAABQIAEAAAokAABAgQQAACiQAAAABRIAAKBAAgAAFEgAAIACCQAAUCABAAAKJAAAQIEEAAAokAAAAAUSAACgQAIAABRIAACAAgkAAFAgAQAACiQAAECBBAAAKJAAAAAFEgAAoEACAAAUSAAAgAIJAABQIAEAAAokAABAgQQAACiQAAAABRIAAKBAAgAAFEgAAIACCQAAUCABAAAKJAAAQIEEAAAokAAAAAUSAACgQAIAABRIAACAAgkAAFAgAQAACiQAAECBBAAAKJAAAAAFEgAAoEACAAAUSAAAgAIJAABQnJT+H2jYv13qbOmXAAAAAElFTkSuQmCC');
    } else {
      register = widget.registerCar;
      nome = TextEditingController(text: register!['nome']);
      marca = TextEditingController(text: register!['marca']);
      modelo = TextEditingController(text: register!['modelo']);
      ano = TextEditingController(text: register!['ano'].toString());
      cidadeBrasileira =
          TextEditingController(text: register!['cidade_brasileira']);
      kilometragem =
          TextEditingController(text: register!['kilometragem'].toString());
      valor = TextEditingController(text: register!['valor'].toString());
    }
  }

  @override
  void initState() {
    super.initState();
    future = initScreen();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(
              child: Text(
                'Carregando...',
                style: TextStyle(
                  fontFamily: 'Rubik',
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  color: Colors.black38,
                ),
              ),
            ),
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              title: Text(widget.registerCar != null
                  ? 'Registro: ${register!['id']}'
                  : 'Novo registro'),
              actions: [
                IconButton(
                  onPressed: widget.registerCar != null
                      ? () async {
                          var token = await push(context, const Login());
                          if (token != '') {
                            if (mounted) {
                              var value = await dataProvider.deleteCar(
                                context,
                                register!['id'],
                                token,
                              );
                              if (value == true) {
                                if (mounted) {
                                  Navigator.pop(context, true);
                                }
                              }
                            }
                          }
                        }
                      : null,
                  icon: const Icon(
                    Icons.delete,
                  ),
                ),
              ],
            ),
            body: LayoutBuilder(
              builder: (context, constraints) {
                return SizedBox(
                  height: constraints.maxHeight,
                  width: constraints.maxWidth,
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        buildWithImage(),
                        InputText(
                          controller: nome,
                          labeltext: 'Nome',
                        ),
                        InputText(
                          controller: marca,
                          labeltext: 'Marca',
                        ),
                        InputText(
                          controller: modelo,
                          labeltext: 'Modelo',
                        ),
                        InputText(
                          controller: ano,
                          labeltext: 'Ano',
                          typeKeyboard: TextInputType.number,
                        ),
                        InputText(
                          controller: cidadeBrasileira,
                          labeltext: 'Cidade',
                        ),
                        InputText(
                          controller: kilometragem,
                          labeltext: 'Kilometragem',
                          typeKeyboard: TextInputType.number,
                        ),
                        InputText(
                          controller: valor,
                          labeltext: 'Valor',
                          typeKeyboard: TextInputType.number,
                        ),
                        appWidgets.buildPrimaryButton(
                          () async {
                            // Validar usuário aqui
                            var token = await push(context, const Login());
                            await dataSave(token);
                          },
                          label: "SALVAR",
                          enable: nome.text.isNotEmpty &&
                              marca.text.isNotEmpty &&
                              modelo.text.isNotEmpty &&
                              ano.text.isNotEmpty &&
                              cidadeBrasileira.text.isNotEmpty &&
                              kilometragem.text.isNotEmpty &&
                              valor.text.isNotEmpty,
                          buttonColor: appStyles.primaryColor,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }

  String uint8ListToBase64(Uint8List uint8List) {
    // Converte o Uint8List em uma lista de bytes
    List<int> bytes = uint8List.toList();

    // Codifica os bytes em uma string base64
    String base64String = base64.encode(bytes);

    return base64String;
  }

  dataSave(String token) async {
    register = {
      "id": register!['id'],
      "nome": nome.text,
      "marca": marca.text,
      "modelo": modelo.text,
      "foto_base64": uint8ListToBase64(register?['bytes']),
      "ano": ano.text,
      "cidade_brasileira": cidadeBrasileira.text,
      "kilometragem": kilometragem.text,
      "valor": valor.text,
      "local_imagem": ""
    };

    if (widget.registerCar == null) {
      var value = await dataProvider.newCar(context, register!, token);
      if (value == true) {
        if (mounted) {
          Navigator.pop(context, true);
        }
      }
    } else {
      var value = await dataProvider.editCar(context, register!, token);
      if (value == true) {
        if (mounted) {
          Navigator.pop(context, true);
        }
      }
    }
  }

  Widget buildWithImage() {
    Future<void> insertImage(ImageSource source) async {
      final xFile = await ImagePicker().pickImage(source: source);
      if (mounted) {
        Navigator.pop(context);
      }
      if (xFile != null) {
        final bytes = await xFile.readAsBytes().then((value) async {
          return await FlutterImageCompress.compressWithList(
            value,
            quality: 50,
            minHeight: 500,
            minWidth: 500,
          );
        });

        setState(() {
          register!['bytes'] = bytes;
        });
      }
    }

    return InkWell(
      onTap: () async {
        await showDialog(
          context: context,
          builder: (ctx) => buildAlertDialog(
            ctx,
            'CARREGAR FOTO',
            'De onde você deseja enviar a foto?',
            'Câmera',
            'Galeria',
            () async => await insertImage(ImageSource.camera),
            () async => await insertImage(ImageSource.gallery),
          ),
        );
      },
      onLongPress: () async {
        await showDialog(
          context: context,
          builder: (ctx) => buildAlertDialog(
            ctx,
            'REMOVER FOTO',
            'Confirmar remoção desta foto?',
            'SIM',
            'NÃO',
            () {
              setState(() {
                evidences.removeAt(0);
              });
              Navigator.of(ctx).pop();
            },
            () => Navigator.of(ctx).pop(),
          ),
        );
      },
      child: SizedBox(
        height: 175,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black54, width: 0.3),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: MemoryImage(register!['bytes']),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildAlertDialog(
    BuildContext ctx,
    String title,
    String message,
    String leftButtonTitle,
    String rightButtonTitle,
    void Function() leftButtonFunction,
    void Function() rightButtonFunction,
  ) =>
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        contentPadding: EdgeInsets.zero,
        content: Container(
          width: 200,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: appStyles.secondaryColor3, width: 1.0),
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 14),
              Text(
                title,
                style: TextStyle(
                    color: Colors.grey.shade700, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                message,
                style: TextStyle(color: Colors.grey.shade600),
                textAlign: TextAlign.center,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                      onPressed: leftButtonFunction,
                      child: Text(leftButtonTitle)),
                  TextButton(
                      onPressed: rightButtonFunction,
                      child: Text(rightButtonTitle)),
                ],
              ),
            ],
          ),
        ),
      );
  Widget buildRoundedTextField({
    required String label,
    required TextEditingController controller,
    required Function(String) onChanged,
    double fontSize = 20,
    double? boxHeight,
    int? maxLines,
    bool? enabled,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.black87, fontSize: 14.0),
        ),
        const SizedBox(height: 2.0),
        Container(
          height: boxHeight ?? fontSize + 10,
          width: double.infinity,
          decoration: BoxDecoration(
            color: enabled == false ? Colors.grey.shade400 : Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(4.0)),
            border: Border.all(color: Colors.black38, width: 1.0),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
          alignment: Alignment.centerLeft,
          child: TextFormField(
              controller: controller,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintStyle: TextStyle(fontSize: fontSize),
                  labelStyle: TextStyle(fontSize: fontSize)),
              onChanged: onChanged,
              maxLines: maxLines,
              enabled: enabled),
        ),
      ],
    );
  }
}

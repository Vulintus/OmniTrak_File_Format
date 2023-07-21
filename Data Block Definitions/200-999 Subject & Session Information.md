## Subject and Session Information Data Blocks

---

| Block Code (uint16) | Definition Name | Description |
| - | - | - |
| 200 | [SUBJECT_NAME](#block-code-200) | A single subject's name. |
| 201 | [GROUP_NAME](#block-code-201) | The subject's or subjects' experimental group name. |
| 300 | [EXP_NAME](#block-code-300) | The user's name for the current experiment. |
| 301 | [TASK_TYPE](#block-code-301) | The user's name for task type, which can be a variant of the overall experiment type. |
| 400 | [STAGE_NAME](#block-code-400) | The stage name for a behavioral session. |
| 401 | [STAGE_DESCRIPTION](#block-code-401) | The stage description for a behavioral session. |

---

* #### Block Code: 200
  * Block Definition: SUBJECT_NAME
  * Description: "A singular subject's name for the present data. If data is collected in one file from a group of subjects, use block code 202."
  * Status:
  * Block Format:
    * 1x (uint16): number of characters to follow.
    * Nx (char): characters of the subject's name.

---

* #### Block Code: 201
  * Block Definition: GROUP_NAME
  * Description: "The subject's or subjects' experimental group name."
  * Status:
  * Block Format:
    * 1x (uint16): number of characters to follow.
    * Nx (char): characters of the experimental group name.

---

* #### Block Code: 202
  * Block Definition: MULTI_SUBJECTS_NAME
  * Description: "Multiple subject's names when data is collected in one file from a group of subjects."
  * Status:
  * Block Format:
    * 1x (uint16): number of subjects
      * 1x (uint16): number of characters to follow.
      * Nx (char): characters of the subject's name.
      * repeat for all subjects...

---

* #### Block Code: 300
  * Block Definition: EXP_NAME
  * Description: "The user's name for the current experiment."
  * Status:
  * Block Format:
    * 1x (uint16): number of characters to follow.
    * Nx (char): characters of the current experiment name.

---

* #### Block Code: 301
  * Block Definition: TASK_TYPE
  * Description: "The user's name for task type, which can be a variant of the overall experiment type."
  * Status:
  * Block Format:
    * 1x (uint16): number of characters to follow.
    * Nx (char): characters of the task type.

---

* #### Block Code: 400
  * Block Definition: STAGE_NAME
  * Description: "The training/testing stage name for a behavioral session."
  * Status:
  * Block Format:
    * 1x (uint16): number of characters to follow.
    * Nx (char): characters of the stage name.

---

* #### Block Code: 401
  * Block Definition: STAGE_DESCRIPTION
  * Description: "The stage description for a behavioral session."
  * Status:
  * Block Format:
    * 1x (uint16): number of characters to follow.
    * Nx (char): characters of the stage description.

---

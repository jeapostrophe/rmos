#lang racket/base
(require rmc
         rmc/h/libc
         rmc/h/glfw)

(define main
  ($proc () S32
         ($unless (glfwInit)
                  ($do ($fprintf stderr ($v "GLFW3: failed to initialize\n")))
                  ($ret ($v S32 1)))
         ($do ($printf ($v "GLFW3 Version: %s\n") (glfwGetVersionString)))

         ($do (glfwWindowHint GLFW_SAMPLES ($v S32 4)))
         ($do (glfwWindowHint GLFW_CONTEXT_VERSION_MAJOR ($v S32 3)))
         ($do (glfwWindowHint GLFW_CONTEXT_VERSION_MINOR ($v S32 3)))
         ($do (glfwWindowHint GLFW_RESIZABLE GL_TRUE))
         ($do (glfwWindowHint GLFW_OPENGL_FORWARD_COMPAT GL_TRUE))
         ($do (glfwWindowHint GLFW_OPENGL_PROFILE GLFW_OPENGL_CORE_PROFILE))

         ($let* ([GLFWmonitor* mon (glfwGetPrimaryMonitor)]
                 [GLFWvidmode* vm (glfwGetVideoMode mon)]
                 [GLFWwindow* w (glfwCreateWindow ($@ vm -> #:width)
                                                  ($@ vm -> #:height)
                                                  ;; window name
                                                  ($v "RMOS")
                                                  ;; $NULL - window
                                                  ;; mon - full-screen
                                                  $NULL
                                                  $NULL)])
                ($do (glfwSetInputMode w GLFW_CURSOR GLFW_CURSOR_NORMAL))
                ($do (glfwMakeContextCurrent w))
                ;; This enables vsync
                ($do (glfwSwapInterval ($v S32 1)))

                ;; XXX Set up the drawing

                ($do (glfwSetKeyCallback
                      w
                      ($proc ([GLFWwindow* w]
                              [S32 k] [S32 sc] [GLFWKeyAction a] [S32 mod])
                             Void
                             ($when ($and ($== k GLFW_KEY_ESCAPE)
                                          ($== a GLFW_PRESS)
                                          ($== mod ($v S32 0))
                                          ($>= sc ($v S32 0)))
                                    ($do (glfwSetWindowShouldClose w GL_TRUE)))
                             ($return))))
                ($while ($! (glfwWindowShouldClose w))
                        ;; XXX Actually do drawing
                        ($do (glfwSwapBuffers w))
                        ($do (glfwPollEvents))))

         ($do (glfwTerminate))
         ($ret ($v S32 0))))

(define this
  ($default-flags ($exe main)))

(module+ test
  (run this))

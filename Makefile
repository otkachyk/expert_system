
NAME = expert_system

SRC = main.c

OBJ = $(SRCS: .c = .o)

FL = -Wall -Wextra -Werror

.PHONY = clean fclean re

all: $(NAME)

$(NAME):
		gcc $(FL) -c $(SRC)
		ar rc $(NAME) $(OBJ)
clean:
		rm -rf $(OBJ)
fclean:	clean
		rm -rf $(NAME)
re:		fclean all

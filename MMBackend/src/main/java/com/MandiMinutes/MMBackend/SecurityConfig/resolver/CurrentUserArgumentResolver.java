package com.MandiMinutes.MMBackend.SecurityConfig.resolver;

import com.MandiMinutes.MMBackend.SecurityConfig.annotation.CurrentUser;
import com.MandiMinutes.MMBackend.User.User;
import com.MandiMinutes.MMBackend.User.UserRepository;
import org.jspecify.annotations.Nullable;
import org.springframework.core.MethodParameter;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;
import org.springframework.web.bind.support.WebDataBinderFactory;
import org.springframework.web.context.request.NativeWebRequest;
import org.springframework.web.method.support.HandlerMethodArgumentResolver;
import org.springframework.web.method.support.ModelAndViewContainer;
import org.springframework.security.access.AccessDeniedException;

@Component
public class CurrentUserArgumentResolver implements HandlerMethodArgumentResolver {

    private final UserRepository userRepository;

    public CurrentUserArgumentResolver(UserRepository userRepository){
        this.userRepository= userRepository;
    }
    @Override
    public boolean supportsParameter(MethodParameter parameter) {
        return parameter.hasParameterAnnotation(CurrentUser.class)
                && parameter.getParameterType().equals(Long.class);
    }

    @Override
    public @Nullable Object resolveArgument(MethodParameter parameter, @Nullable ModelAndViewContainer mavContainer, NativeWebRequest webRequest, @Nullable WebDataBinderFactory binderFactory) throws Exception {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null || !authentication.isAuthenticated() || "anonymousUser".equals(authentication.getPrincipal())) {
            throw new AccessDeniedException("User is not authenticated or session has expired.");
        }
        String email = authentication.getName();
        if (email != null) {
            User user = userRepository.findByEmail(email);
            if (user != null) {
                return user.getId();
            }
        }

        //  FIX 2: Silent null return karne ke bajaye exception throw karo agar user DB mein na mile
        throw new AccessDeniedException("User details not found for principal: " + email);
    }
}

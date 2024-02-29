#!/bin/bash

function create_directories() {
    local base_package=$1
    local directories=("config" "controllers"  "controllers" "converters" "entities" "exceptions" "facades" "facades/impl" "facades/interfaces" "facades/interfaces/commons" "payloads/requests" "payloads/responses" "repositories" "services" "services/interfaces" "services/interfaces/commons" "services/impls" "services/impls/commons")

    for dir in "${directories[@]}"
    do
        mkdir -p "src/main/java/$(echo $base_package | tr '.' '/')/$dir"
    done
}

function create_config(){
  local class_name=$1
  local base_package=$2

   if [ ! -f src/main/java/$(echo $base_package | tr '.' '/')/config/AppConfig.java ]; then
         cat <<EOF > "src/main/java/$(echo $base_package | tr '.' '/')/config/AppConfig.java"
    package ${base_package}.config;


    import org.modelmapper.ModelMapper;
    import org.springframework.context.annotation.Bean;
    import org.springframework.context.annotation.Configuration;

    @Configuration
    public class AppConfig {

        @Bean
        public ModelMapper modelMapper() {


            return   new ModelMapper();
        }

    }
EOF
    fi
}


function create_crud(){
  local class_name=$1
  local base_package=$2

   if [ ! -f src/main/java/$(echo $base_package | tr '.' '/')/services/interfaces/commons/Crud.java ]; then


  echo "package ${base_package}.services.interfaces.commons;

  import org.springframework.data.domain.Page;
  import org.springframework.data.domain.Pageable;

  import java.util.UUID;

  public interface Crud<T> {
      Page<T> readAll(Pageable pageable);
      T save(T t);
      T readById(UUID uuid);

      void delete(T t);
  }

  "   > src/main/java/$(echo $base_package | tr '.' '/')/services/interfaces/commons/Crud.java

    fi

}
function create_crud_facade() {
    local class_name=$1
    local base_package=$2
    echo "
    package ${base_package}.facades.interfaces.commons;
    import org.springframework.data.domain.Page;
    import org.springframework.data.domain.Pageable;
    import java.util.UUID;

    public interface FacadeCrud<A,B> {
        Page<B> readAll(Pageable pageable);
        B create(A a);
        B readById(UUID uuid);
        B update(UUID uuid, A a);
        void delete(UUID uuid);
    }
    " > src/main/java/$(echo $base_package | tr '.' '/')/facades/interfaces/commons/FacadeCrud.java

}
function create_entity() {
  local class_name=$1
      local base_package=$2
    echo "package ${base_package}.entities;

    import jakarta.persistence.Entity;

    @Entity
    public class ${class_name} {

    }" > src/main/java/$(echo $base_package | tr '.' '/')/entities/${class_name}.java
}
function create_repository() {
    local class_name=$1
    local base_package=$2
    echo "
    package ${base_package}.repositories;

    import org.springframework.data.jpa.repository.JpaRepository;
    import ${base_package}.entities.${class_name};
     import java.util.UUID;

    public interface ${class_name}Repository extends JpaRepository<${class_name}, UUID> {

    }" > src/main/java/$(echo $base_package | tr '.' '/')/repositories/${class_name}Repository.java
    }
function create_service() {
   local class_name=$1
           local base_package=$2
   echo "
   package ${base_package}.services.interfaces;

   import org.springframework.stereotype.Service;
   import ${base_package}.entities.${class_name};
   import ${base_package}.services.interfaces.commons.Crud;

   public interface ${class_name}Service extends Crud<${class_name}> {


   }
   " > src/main/java/$(echo $base_package | tr '.' '/')/services/interfaces/${class_name}Service.java

 }
function create_service_impl() {
      local class_name=$1
      local base_package=$2
   echo "
      package ${base_package}.services.impls;

      import lombok.RequiredArgsConstructor;
      import org.springframework.data.domain.Page;
      import org.springframework.data.domain.Pageable;
      import org.springframework.stereotype.Service;
      import ${base_package}.entities.${class_name};
      import ${base_package}.exceptions.AlreadyExistException;
      import ${base_package}.exceptions.Error;
      import ${base_package}.exceptions.NotFoundException;
      import ${base_package}.repositories.${class_name}Repository;
      import ${base_package}.services.interfaces.${class_name}Service;

      import java.util.UUID;
      @Service
      @RequiredArgsConstructor
      public class ${class_name}ServiceImpl implements ${class_name}Service {

          private static final String TYPE = "\"${class_name}"\";
          private final ${class_name}Repository repository;

          @Override
          public Page<${class_name}> readAll(Pageable pageable) {
              return repository.findAll(pageable);
          }

          @Override
          public ${class_name} save(${class_name} data) {
              return repository.save(data);
          }

          @Override
          public ${class_name} readById(UUID id) {
              return repository.findById(id).orElseThrow(() ->
                      new NotFoundException(
                              Error.builder()
                                      .type(TYPE)
                                      .message(String.format(\"${class_name} not found with ID %s\", id))
                                      .field(\"id\")
                                      .value(id)
                                      .build()
                      )
              );
          }

          @Override
          public void delete(${class_name} data) {
              repository.delete(data);
          }


      }

   " > src/main/java/$(echo $base_package | tr '.' '/')/services/impls/${class_name}ServiceImpl.java

 }
function create_request_payload() {
    local class_name=$1
    local base_package=$2
    echo "
    package ${base_package}.payloads.requests;

    public class ${class_name}Request {

    }
    " > src/main/java/$(echo $base_package | tr '.' '/')/payloads/requests/${class_name}Request.java
}
function create_response_payload() {
    local class_name=$1
    local base_package=$2
    echo "
    package ${base_package}.payloads.responses;

    public class ${class_name}Response {

    }
    " > src/main/java/$(echo $base_package | tr '.' '/')/payloads/responses/${class_name}Response.java
}
function  create_facade() {
      local class_name=$1
      local base_package=$2
      echo "
      package ${base_package}.facades.interfaces;


      import ${base_package}.facades.interfaces.commons.FacadeCrud;
      import ${base_package}.payloads.requests.${class_name}Request;
      import ${base_package}.payloads.responses.${class_name}Response;

      public interface ${class_name}Facade extends FacadeCrud<${class_name}Request,${class_name}Response> {

      }
      " > src/main/java/$(echo $base_package | tr '.' '/')/facades/interfaces/${class_name}Facade.java

 }
function create_facade_impl() {
    local class_name=$1
    local base_package=$2
    echo "
    package ${base_package}.facades.impl;

    import lombok.RequiredArgsConstructor;
    import org.springframework.stereotype.Service;
    import ${base_package}.converters.${class_name}Converter;
    import ${base_package}.entities.${class_name};
    import ${base_package}.facades.interfaces.${class_name}Facade;
    import ${base_package}.payloads.requests.${class_name}Request;
    import ${base_package}.payloads.responses.${class_name}Response;
    import ${base_package}.services.interfaces.${class_name}Service;
    import org.springframework.data.domain.Page;
    import org.springframework.data.domain.Pageable;

    import java.util.UUID;


@RequiredArgsConstructor
@Service
public class ${class_name}FacadeImpl implements ${class_name}Facade {
    private final ${class_name}Service service;
    private final ${class_name}Converter converter;

    @Override
    public Page<${class_name}Response> readAll(Pageable pageable) {
        return service.readAll(pageable).map(converter::convert);
    }

    @Override
    public ${class_name}Response create(${class_name}Request request) {
        ${class_name} data = converter.convert(request);
        return converter.convert(service.save(data));
    }

    @Override
    public ${class_name}Response readById(UUID uuid) {
        return converter.convert(service.readById(uuid));
    }

    @Override
    public ${class_name}Response update(UUID uuid, ${class_name}Request request) {
           ${class_name} data = converter.convert(request);
                 return converter.convert(service.save(data));
    }
   @Override
    public void delete(UUID uuid) {
        service.delete(service.readById(uuid));

    }
  }
    " > src/main/java/$(echo $base_package | tr '.' '/')/facades/impl/${class_name}FacadeImpl.java

}
function create_converter() {
    local class_name=$1
    local base_package=$2
    echo "
package ${base_package}.converters;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Component;
import ${base_package}.entities.${class_name};
import ${base_package}.payloads.requests.${class_name}Request;
import ${base_package}.payloads.responses.${class_name}Response;

@Component
@RequiredArgsConstructor
public class ${class_name}Converter {

    private final  ModelMapper modelMapper;

    public ${class_name} convert(${class_name}Request request) {
        return  modelMapper.map(request, ${class_name}.class);

    }

    public ${class_name}Response convert(${class_name} data) {
        return  modelMapper.map(data, ${class_name}Response.class);
    }
}

    " > src/main/java/$(echo $base_package | tr '.' '/')/converters/${class_name}Converter.java

}
function create_controller() {
    local class_name=$1
    local base_package=$2
    local class_name_lowercase=$(echo $class_name | tr '[:upper:]' '[:lower:]')

    echo "
    package ${base_package}.controllers;


import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.web.bind.annotation.*;
import ${base_package}.facades.interfaces.${class_name}Facade;
import ${base_package}.payloads.responses.${class_name}Response;
import ${base_package}.payloads.requests.${class_name}Request;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import java.util.UUID;

@RestController
@RequestMapping(\"/${class_name_lowercase}\")
@RequiredArgsConstructor
public class ${class_name}Controller {

    private final ${class_name}Facade facade;


    @GetMapping
    public Page<${class_name}Response> readAll(Pageable pageable) {
        return facade.readAll(pageable);
    }

    @PostMapping
    public ${class_name}Response create(@Valid @RequestBody ${class_name}Request request) {
        return facade.create(request);
    }

    @GetMapping(\"/{uuid}\")
    public ${class_name}Response readById(@PathVariable UUID uuid) {
        return facade.readById(uuid);
    }

    @PutMapping(\"/{uuid}\")
    public ${class_name}Response update(@PathVariable UUID uuid, @Valid @RequestBody ${class_name}Request request) {
        return facade.update(uuid, request);
    }

    @DeleteMapping(\"/{uuid}\")
    public void delete(@PathVariable UUID uuid) {
        facade.delete(uuid);
    }
}
    " > src/main/java/$(echo $base_package | tr '.' '/')/controllers/${class_name}Controller.java

}


function create_exception() {
  local class_name=$1
  local base_package=$2

   if [ ! -f src/main/java/$(echo $base_package | tr '.' '/')/exceptions/Error.java ]; then


 echo "

       package ${base_package}.exceptions;

      import lombok.Builder;
      import lombok.Data;

      @Data
      @Builder
      public class Error {
          private  String type;
          private String message;
          private Object value;
          private Object field;
      }
      " > src/main/java/$(echo $base_package | tr '.' '/')/exceptions/Error.java

echo "
package ${base_package}.exceptions;
import lombok.*;

@Getter
@Setter
public class NotFoundException  extends  RuntimeException{
    private Error error;

    public NotFoundException(  Error error) {
        super(error.getMessage());
        this.error = error;
    }
}
" > src/main/java/$(echo $base_package | tr '.' '/')/exceptions/NotFoundException.java

echo "
      package ${base_package}.exceptions;
      import lombok.*;
        @RequiredArgsConstructor
        @Getter
        @Setter
        public class AlreadyExistException extends  RuntimeException{
            private final Error error;
        }
      " > src/main/java/$(echo $base_package | tr '.' '/')/exceptions/AlreadyExistException.java

 cat <<EOF > "src/main/java/$(echo $base_package | tr '.' '/')/exceptions/DataUnthorizeProcessingException.java"
package ${base_package}.exceptions;
    import lombok.*;
       @RequiredArgsConstructor
       @Getter
       @Setter
       public class DataUnthorizeProcessingException extends  RuntimeException{
           private final Error error;

       }
EOF



cat <<EOF > "src/main/java/$(echo $base_package | tr '.' '/')/exceptions/GlobalExceptionHandler.java"
package ${base_package}.exceptions;

import jakarta.validation.ConstraintViolationException;
import lombok.extern.slf4j.Slf4j;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.MissingServletRequestParameterException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.method.annotation.MethodArgumentTypeMismatchException;

import java.util.ArrayList;
import java.util.List;

@RestControllerAdvice
@Slf4j
public class GlobalExceptionHandler {

    @ResponseStatus(HttpStatus.NOT_FOUND)
    @ExceptionHandler(value = {NotFoundException.class})
    public Error handleNotFoundException(NotFoundException exception) {
        return exception.getError();
    }
//
    @ResponseStatus(HttpStatus.CONFLICT)
    @ExceptionHandler(value = {AlreadyExistException.class})
    public Error handleAlreadyExistException(AlreadyExistException exception) {
        return exception.getError();
    }

    @ResponseStatus(HttpStatus.BAD_REQUEST)
    @ExceptionHandler(value = {DataUnthorizeProcessingException.class})
    public Error handleDataUnthoerizeProcessingException(DataUnthorizeProcessingException exception) {
        return exception.getError();
    }

    @ExceptionHandler(MethodArgumentNotValidException.class)
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    public List<Error> handleValidationException(MethodArgumentNotValidException ex) {
        log.error("MethodArgumentNotValidException ");
        List<Error> errors = new ArrayList<>();
        ex.getBindingResult().getFieldErrors().forEach(fieldError -> errors.add(Error.builder().type("Validation Error").message(fieldError.getDefaultMessage()).value(fieldError.getRejectedValue()).field(fieldError.getField()).build()));
        return errors;
    }

    @ExceptionHandler(IllegalArgumentException.class)
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    public Error handleIllegalArgumentException(IllegalArgumentException ex) {
        log.error("IllegalArgumentException ");
        return Error.builder()
                .value("")
                .message("IllegalArgumentException")
                .build();
    }

    @ExceptionHandler(ConstraintViolationException.class)
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    public List<Error> handleConstraintViolationException(ConstraintViolationException ex) {
        log.error("ConstraintViolationException ");
        List<Error> errors = new ArrayList<>();
        ex.getConstraintViolations().forEach(constraintViolation ->
                errors.add(Error.builder().type("Constraint Violation")
                        .message(constraintViolation.getMessage())
                        .value(constraintViolation.getInvalidValue().toString())
                        .field(constraintViolation.getPropertyPath().toString())
                        .build())
        );
        return errors;
    }

    @ExceptionHandler(DataIntegrityViolationException.class)
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    public Error handleDataIntegrityViolationException(DataIntegrityViolationException ex) {
        log.error("DataIntegrityViolationException ");

        return Error.builder()
                .type("Data Integrity Violation")
                .message("A data integrity violation occurred: " + ex.getMostSpecificCause().getMessage().split("Detail:")[1])
                .build();
    }

    @ExceptionHandler(MethodArgumentTypeMismatchException.class)
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    public Error handleTypeMismatchException(MethodArgumentTypeMismatchException ex) {
        log.error("MethodArgumentTypeMismatchException ");
        return Error.builder().type("Type Mismatch").message("The parameter '" + ex.getName() + "' should be of type " + ex.getRequiredType().getSimpleName()).value(ex.getValue().toString()).field(ex.getName()).build();
    }

    @ExceptionHandler(MissingServletRequestParameterException.class)
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    public Error handleMissingParameterException(MissingServletRequestParameterException ex) {
        log.error("MissingServletRequestParameterException ");
        return Error.builder().type("Missing Parameter").message("The parameter '" + ex.getParameterName() + "' is missing").field(ex.getParameterName()).build();
    }

    @ExceptionHandler(Exception.class)
    @ResponseStatus(HttpStatus.INTERNAL_SERVER_ERROR)
    public Error handleGenericException(Exception ex) {
        log.error("Exception ");
        return Error.builder().type("Internal Server Error").message("An error occurred: " + ex.getMessage()).build();
    }
}
EOF

    fi




}


# Main script
if [ $# -lt 2 ]; then
    echo "Usage: $0 <command> <args>"
    echo "Commands:"
    echo "  init <base package name>"
    echo "  generate <package name> <class name>"
    exit 1
fi

command=$1
shift

case $command in
    init)
        base_package=$1
        create_directories $base_package
        ;;
    generate)
        package_name=$1
        class_name=$2
        base_package=$(echo $package_name | tr '/' '.')
        create_directories $base_package
        create_config $class_name $base_package
        create_exception $class_name $base_package
        create_crud $class_name $base_package
        create_crud_facade $class_name $base_package
        create_entity $class_name $base_package
        create_repository $class_name $base_package
        create_service $class_name $base_package
        create_service_impl $class_name $base_package
        create_facade $class_name $base_package
        create_facade_impl $class_name $base_package
        create_request_payload $class_name $base_package
        create_response_payload $class_name $base_package
        create_converter $class_name $base_package
        create_controller $class_name $base_package



       # create_java_files $class_name $base_package
        ;;
    *)
        echo "Invalid command: $command"
        echo "Usage: $0 <command> <args>"
        echo "Commands:"
        echo "  init <base package name>"
        echo "  generate <package name> <class name>"
        exit 1
        ;;
esac
